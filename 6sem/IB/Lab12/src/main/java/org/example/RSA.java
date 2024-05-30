package org.example;

import java.security.*;
import java.util.Base64;

public class RSA {
    private PublicKey publicKey;
    private PrivateKey privateKey;
    private byte[] signature;

    public boolean generateKeysSignAndVerify(byte[] data) throws Exception {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair keyPair = keyGen.generateKeyPair();
        publicKey = keyPair.getPublic();
        privateKey = keyPair.getPrivate();

        Signature rsaSignature = Signature.getInstance("SHA256withRSA");
        rsaSignature.initSign(privateKey);
        rsaSignature.update(data);
        signature = rsaSignature.sign();

        // Verify signature
        rsaSignature.initVerify(publicKey);
        rsaSignature.update(data);
        return rsaSignature.verify(signature);
    }

    public String getPublicKeyBase64() {
        return Base64.getEncoder().encodeToString(publicKey.getEncoded());
    }

    public String getPrivateKeyBase64() {
        return Base64.getEncoder().encodeToString(privateKey.getEncoded());
    }

    public String getSignatureBase64() {
        return Base64.getEncoder().encodeToString(signature);
    }
}
