package com.example;


public class FunctionOutput {
  private final String signedPayload;

  public FunctionOutput(String signedPayload) {
    this.signedPayload = signedPayload;
  }

  public String getSignedPayload() {
    return signedPayload;
  }
}
