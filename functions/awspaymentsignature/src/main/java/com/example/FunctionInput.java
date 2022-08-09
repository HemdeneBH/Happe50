package com.example;

public class FunctionInput {
    private final String payload;
    private final String privateKeyFileName;

    public FunctionInput(String payload, String privateKeyFileName) {
        this.payload = payload;
        this.privateKeyFileName = privateKeyFileName;
    }

    public String getPayload() {
        return payload;
    }

    public String getPrivateKeyFileName() {
        return privateKeyFileName;
    }
}
