// Source: https://www.sohamkamani.com/nodejs/rsa-encryption/
const crypto = require("crypto"); 

// The generateKeyPairSync method accepts two arguments 
// 1. The type of keys we want, which in this case is "rsa"
// 2. An object with the properties of the key 
const { publicKey, privateKey } = crypto.generateKeyPairSync("rsa", {
    // The standard secure default length for RSA keys is 2048 bits 
    modulusLength: 2048,
})

console.log(`Public key: ${publicKey.toString("base64")}`); 
console.log(`Private key: ${privateKey.toString("base64")}`); 

const data = "my secret data"; 

const encryptData = crypto.publicEncrypt(
    {
        key: publicKey, 
        padding: crypto.constants.RSA_PKCS1_OAEP_PADDING, 
        oaepHash: "sha256",
    }, 
    // We convert the data string to a buffer using 'Buffer.from`
    Buffer.from(data)
); 

// Thw encrypted data is in the form of bytes, so we print it in base64 format 
// so that it's displayed in a more readable form
let cifra = encryptData.toString("base64"); 
console.log(`Encrypted data: ${cifra} with the length of ${cifra.length}`); 

const dectyptData = crypto.privateDecrypt(
    {
        key: privateKey, 
        // In order to decrypt data, we need to specify the 
        // same hashing function and padding scheme that we used 
        // to encrypt the data in the previous step 
        padding: crypto.constants.RSA_PKCS1_OAEP_PADDING, 
        oaepHash: "sha256",
    },
    encryptData
);

// The decrypted data is of the Buffer type, which we can convert to a 
// string to reveal the original data. 
console.log("decrypted data: ", dectyptData.toString()); 

// Create some data that we want to sign 
const verifiableData = "this needs to be verified"; 

// The signature method takes the data we want to sign, the 
// hashing algorithm, and the padding scheme, and generates 
// a signature in the form of bytes 
const signature = crypto.sign("sha256", Buffer.from(verifiableData), {
    key: privateKey, 
    padding: crypto.constants.RSA_PKCS1_PSS_PADDING,
})

console.log(`Signature: ${signature.toString("base64")}`);

// To verify the data, we provide the same hashing algorithm and 
// padding scheme we provided to generate the signature, along 
// wih the signature itself, the data we want to verify against 
// the signature, and the public key 
const isVerified = crypto.verify(
    "sha256", Buffer.from(verifiableData), 
    {
        key: publicKey, 
        padding: crypto.constants.RSA_PKCS1_PSS_PADDING
    }, 
    signature
);

// isVerified shoud be true if the signature is valid
console.log(`Signature is verified? ${isVerified}`);