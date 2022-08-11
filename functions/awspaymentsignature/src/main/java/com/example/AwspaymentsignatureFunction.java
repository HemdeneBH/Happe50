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
        byte[] key = Files.readAllBytes(Paths.get(event.getData().getPrivateKeyFileName()));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(key);
        PrivateKey finalKey = keyFactory.generatePrivate(keySpec);
        signature.initSign(finalKey);
        signature.update(event.getData().getPayload().getBytes());

    return new FunctionOutput(new String(Base64.encode(signature.sign())));
  }
}
