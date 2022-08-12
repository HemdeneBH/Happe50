package com.example;

import com.salesforce.functions.jvm.sdk.Context;
import com.salesforce.functions.jvm.sdk.InvocationEvent;
import com.salesforce.functions.jvm.sdk.SalesforceFunction;
import com.salesforce.functions.jvm.sdk.data.Record;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.util.encoders.Base64;
import org.bouncycastle.util.encoders.Hex;

import java.net.URI;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.Security;
import java.security.SignatureException;
import java.security.spec.MGF1ParameterSpec;
import java.security.spec.PSSParameterSpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemReader;
import java.io.CharArrayReader;
import org.apache.commons.io.IOUtils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

/**
 * Describe AwspaymentsignatureFunction here.
 */
public class AwspaymentsignatureFunction implements SalesforceFunction<FunctionInput, FunctionOutput> {
  private static final Logger LOGGER = LoggerFactory.getLogger(AwspaymentsignatureFunction.class);
  public final static int SALT_LENGTH = 20;
  public final static int TRAILER_FIELD = 1;

  @Override
  public FunctionOutput apply(InvocationEvent<FunctionInput> event, Context context)
      throws Exception {
        Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
    final Signature signature = Signature.getInstance("SHA256WithRSA/PSS", BouncyCastleProvider.PROVIDER_NAME);
        final MGF1ParameterSpec mgf1ParameterSpec = new MGF1ParameterSpec("SHA-256");
        final PSSParameterSpec pssParameterSpec = new PSSParameterSpec("SHA-256",
                "MGF1", mgf1ParameterSpec, SALT_LENGTH, TRAILER_FIELD);
        signature.setParameter(pssParameterSpec);
        ClassLoader classLoader = getClass().getClassLoader();         
        InputStream resource = classLoader.getResourceAsStream(event.getData().getPrivateKeyFileName()); 
        char[] data = IOUtils.toCharArray(resource, StandardCharsets.UTF_8);
        PrivateKey finalKey = buildPrivateKey(data);
        signature.initSign(finalKey);
        signature.update(event.getData().getPayload().getBytes());

    return new FunctionOutput(new String(Base64.encode(signature.sign())));
  }

  public static PrivateKey buildPrivateKey(final char[] privateKey) throws Exception {
        Security.addProvider(new BouncyCastleProvider());
        if (privateKey == null || privateKey.length == 0) {
             throw new Exception("Private key char array cannot be null or empty");
        }
        final PemObject pemObject = getPEMObjectFromKey(privateKey);
        if (pemObject == null) {
            throw new Exception("Private key string provided is not valid");
        }

        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(pemObject.getContent());

        PrivateKey privateKeyObject = null;
        try {
            final KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            privateKeyObject = keyFactory.generatePrivate(spec);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new Exception(e.getMessage(), e);
        }

        return privateKeyObject;
    }

    /**
     * To read the contents of the private key
     * @param char[] privateKey the private key provided
     * @return private key pem object
     * @throws AmazonPayClientException When an error response is returned by Amazon Pay due to bad request or other issue
     */
    private static PemObject getPEMObjectFromKey(final char[] privateKey) throws Exception {
        PemObject pemObject ;
        try {
            final PemReader pemReader = new PemReader(new CharArrayReader(privateKey));
            pemObject = pemReader.readPemObject();
            pemReader.close();

        } catch (Exception e) {
          LOGGER.info("e.getMessage() : " + e.getMessage());
            throw new Exception(e.getMessage(), e);
        }

        return pemObject;
    }

    public static char[] bytesToChar(byte[] bytes) {
        char[] buffer = new char[bytes.length >> 1];
        for (int i = 0; i < buffer.length; i++) {
            int bpos = i << 1;
            char c = (char) (((bytes[bpos] & 0x00FF) << 8) + (bytes[bpos + 1] & 0x00FF));
            buffer[i] = c;/*from w ww. j a  v a 2 s  . c o m*/
        }
        return buffer;
    }
}