//
//  TinggSecurity.swift
//
//
//  Created by Abdulrasaq on 24/07/2023.
//
import Alamofire
import CommonCrypto
import CryptoSwift
import Foundation
import CryptoKit

enum CryptoError: Error {
    case randomGenerationFailed(OSStatus)
    case aesOperationFailed(CCStatus)
}

protocol Authentication {
    static func performBasicAuthentication(_ username: String, _ password: String, _ url: String) async throws -> String
}

protocol SymmetricSecurity {
    static func symmetricEncrypt(plainText: String, secretKeyBase64: String, ivBase64: String) -> String?
    static func symmetricDecrypt(ciphertextBase64: Base64String, secretKeyBase64: Base64String, ivBase64: Base64String) -> String?
}

protocol AsymmetricSecurity {
    static func asymmetricEncrypt(_ plainText: String, publicKey: SecKey) throws -> Data
    static func asymmetricDecrypt(_ encryptedData: Data, privateKey: SecKey) throws -> String
}

public class TinggSecurity: SymmetricSecurity, AsymmetricSecurity {
    public static let JKSPASSWORD = "[qwertyuiop]"
    public static let JKSALIAS = "tingg"
    private static let ISUSERLOGINKEY = "isUserLoginEncryptionKey"
    public init() {
        //
    }

    public static func symmetricEncrypt(plainText: String, secretKeyBase64: String, ivBase64: String) -> String? {
        do {
            guard let secretKeyData = Data(base64Encoded: secretKeyBase64),
                  let ivData = Data(base64Encoded: ivBase64) else {
                return nil
            }

            // Convert SymmetricKey to byte array
            let actualSecretKey = Array(secretKeyData)

            // Convert IV (Initialization Vector) to byte array
            let iv = Array(ivData)

            // Convert plain text to byte array
            guard let plainTextData = plainText.data(using: .utf8) else {
                return nil
            }
            let plaintextBytes = Array(plainTextData)

            // Perform AES/GCM encryption using CryptoSwift
            let gcm = GCM(iv: iv, mode: .combined)
            let encryptedBytes = try CryptoSwift.AES(key: actualSecretKey, blockMode: gcm, padding: .noPadding).encrypt(plaintextBytes)

            // Convert encrypted byte array to Base64-encoded String
            let encryptedData = Data(encryptedBytes)
            return encryptedData.base64EncodedString()
        } catch {
            print(error)
        }
        return nil
    }

    public static func symmetricDecrypt(ciphertextBase64: String, secretKeyBase64: String, ivBase64: String) -> String? {
        do {
            guard let ciphertextData = Data(base64Encoded: ciphertextBase64),
                  let secretKeyData = Data(base64Encoded: secretKeyBase64),
                  let ivData = Data(base64Encoded: ivBase64) else {
                return nil
            }

            // Convert SymmetricKey to byte array
            let actualSecretKey = Array(secretKeyData)

            // Convert IV (Initialization Vector) to byte array
            let iv = Array(ivData)

            // Perform AES/GCM decryption using CryptoSwift
            let gcm = GCM(iv: iv, mode: .combined)
            let decryptedBytes = try CryptoSwift.AES(key: actualSecretKey, blockMode: gcm, padding: .noPadding).decrypt(ciphertextData.bytes)

            // Convert decrypted byte array to String
            if let decryptedString = String(bytes: decryptedBytes, encoding: .utf8) {
                return decryptedString
            }
        } catch {
            print(error)
        }
        return nil
    }

    public static func aesEncryption(data: String, key: String, iv: String) -> Data? {
        do {
            if let data = data.data(using: .utf8), let iv = iv.data(using: .utf8), let key = key.data(using: .utf8) {
                return try performAESOperation(data: data, key: key, iv: iv, operation: CCOperation(kCCEncrypt))
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    public static func aesDecryption(data: String, key: String, iv: String) -> Data? {
        do {
            if let data = data.data(using: .utf8), let iv = iv.data(using: .utf8), let key = key.data(using: .utf8) {
                return try performAESOperation(data: data, key: key, iv: iv, operation: CCOperation(kCCDecrypt))
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    private static func performAESOperation(data: Data, key: Data, iv: Data, operation: CCOperation) throws -> Data {
        let dataLength = data.count
        let keyLength = key.count
        _ = iv.count

        let bufferSize = dataLength + kCCBlockSizeAES128
        var outputData = Data(count: bufferSize)
        var outputDataLength: size_t = 0

        let status = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { dataBytes in
                    outputData.withUnsafeMutableBytes { outputBytes in
                        CCCrypt(
                            operation,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, dataLength,
                            outputBytes.baseAddress, bufferSize,
                            &outputDataLength
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else {
            throw CryptoError.aesOperationFailed(status)
        }

        // Create a new Data object with the output data
        return Data(outputData.prefix(outputDataLength))
    }
    public static func simpleEncryption<T: Encodable>(_ value: T) throws -> Data? {
        let encoder = JSONEncoder()
        return try? CryptoKit.AES.GCM.seal(encoder.encode(value), using: getKey()).combined
    }

    public static func simptleDecryption<T: Decodable>(_ data: Data?) throws -> T? {
        guard let data = data else { return nil }
        let sealedBox = try CryptoKit.AES.GCM.SealedBox(combined: data)
        let decryptedData = try CryptoKit.AES.GCM.open(sealedBox, using: getKey())
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: decryptedData)
    }

    public static func getKey() -> SymmetricKey {
        let keyString = TinggSecurity.ISUSERLOGINKEY
        return SymmetricKey(data: keyString.data(using: .utf8)!)
    }
    func generateRandomData(length: Int) throws -> Data {
        var data = Data(count: length)

        let result = data.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, length, $0.baseAddress!)
        }

        guard result == errSecSuccess else {
            throw CryptoError.randomGenerationFailed(result)
        }

        return data
    }

    public static func generateRandomAlphanumericString(length: Int) -> String {
        let alphanumericCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let randomString = (0 ..< length).map { _ in alphanumericCharacters.randomElement()! }
        return String(randomString)
    }

    public static func getKeysFromJKSFile(jksFilePath: String, jksPassword: String, alias: String) throws -> (privateKey: SecKey, publicKey: SecKey) {
        // Load the JKS file data
        let jksURL = URL(fileURLWithPath: jksFilePath)
        let jksData = try Data(contentsOf: jksURL)

        // Import the JKS data into the keychain
        var importedItems: CFArray?
        let importStatus = SecPKCS12Import(jksData as NSData, [kSecImportExportPassphrase: jksPassword] as CFDictionary, &importedItems)

        guard importStatus == errSecSuccess else {
            throw NSError(domain: "KeyStoreError", code: Int(importStatus), userInfo: [NSLocalizedDescriptionKey: "Failed to import JKS data into the keychain."])
        }

        // Extract the private key and certificate from the imported items
        guard let items = importedItems as? [[String: Any]], let firstItem = items.first else {
            throw NSError(domain: "KeyStoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to extract private key and certificate from the imported items."])
        }
        let identity = firstItem[kSecImportItemIdentity as String] as! SecIdentity

        // Get the private key from the identity
        var privateKeyRef: SecKey?
        let status = SecIdentityCopyPrivateKey(identity, &privateKeyRef)

        guard status == errSecSuccess, let privateKey = privateKeyRef else {
            throw NSError(domain: "KeyStoreError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve the private key from the identity."])
        }

        // Get the certificate from the identity
        var certificate: SecCertificate?
        SecIdentityCopyCertificate(identity, &certificate)

        // Get the public key from the certificate
        var publicKeyRef: SecKey?
        if let certificate = certificate {
            publicKeyRef = SecCertificateCopyKey(certificate)
        }

        guard let publicKey = publicKeyRef else {
            throw NSError(domain: "KeyStoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve the public key from the certificate."])
        }

        return (privateKey, publicKey)
    }

    public static func convertToBase64String(_ inputString: String) -> String? {
        if let inputData = inputString.data(using: .utf8) {
            return inputData.base64EncodedString()
        }
        return nil
    }

    // Function to encrypt a string using the public key (SecKey)
    public static func asymmetricEncrypt(_ plainText: String, publicKey: SecKey) throws -> Data {
        let plainData = plainText.data(using: .utf8)!

        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA1, plainData as CFData, &error) as Data? else {
            throw (error?.takeRetainedValue() as Error?) ?? EncryptionError.encryptionFailed
        }

        return encryptedData
    }

    // Function to encrypt a string using the public key (SecKey)
    public static func encryptData(_ plainData: Data, publicKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, plainData as CFData, &error) as Data? else {
            throw (error?.takeRetainedValue() as Error?) ?? EncryptionError.encryptionFailed
        }

        return encryptedData
    }

    // Function to decrypt an encrypted Data using the private key (SecKey)
    public static func asymmetricDecrypt(_ encryptedData: Data, privateKey: SecKey) throws -> String {
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA1, encryptedData as CFData, &error) as Data? else {
            throw (error?.takeRetainedValue() as Error?) ?? DecryptionError.decryptionFailed
        }

        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw DecryptionError.decodingFailed
        }

        return decryptedString
    }

    public static func secKeyToData(_ secKey: SecKey?) -> Data? {
        guard let secKey = secKey else { return nil }
        var error: Unmanaged<CFError>?
        if let data = SecKeyCopyExternalRepresentation(secKey, &error) {
            return data as Data
        } else {
            return nil
        }
    }

    public static func dataToSecKey(_ data: Data, isPrivateKey: Bool) -> SecKey? {
        let keyClass: CFString = isPrivateKey ? kSecAttrKeyClassPrivate : kSecAttrKeyClassPublic
        let keyType: CFString = kSecAttrKeyTypeRSA
        let keyAttributes: [CFString: Any] = [
            kSecAttrKeyType: keyType,
            kSecAttrKeyClass: keyClass,
        ]

        var error: Unmanaged<CFError>?
        return SecKeyCreateWithData(data as CFData, keyAttributes as CFDictionary, &error)
    }

    enum EncryptionError: Error {
        case encryptionFailed
    }

    enum DecryptionError: Error {
        case decryptionFailed
        case decodingFailed
    }
}

class TinggAuth: Authentication {
    private static let baseRequest: BaseRequest = BaseRequest(allowResponseDecryption: false)
    init() {
        //
    }

    static func performBasicAuthentication(_ username: String, _ password: String, _ url: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let credentials = "\(username):\(password)"

            guard let credentialData = credentials.data(using: .utf8) else {
                print("Error converting credentials to data")
                return
            }

            let base64Credentials = credentialData.base64EncodedString()

            let headers: HTTPHeaders = [
                "Authorization": "Basic \(base64Credentials)",
            ]
            Task {
                let result: Result<SecuredResponse, ApiError> = try await baseRequest.resultOfBasicAuthRequest(url: url, method: .post, headers: headers)
                switch result {
                case let .success(data):
                    continuation.resume(returning: data.message)
                    print("Basic Auth Data \(data)")
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public struct SecuredResponse: Codable {
    public var message: String
    public init(message: String) {
        self.message = message
    }

    enum CodingKeys: String, CodingKey {
        case message = "MESSAGE"
    }
}

extension SecuredResponse {
    public var json: String {
        get {
            return decryptResponse()!
        }
        set {
            message = newValue
        }
    }

    private func decryptResponse() -> String? {
        let response = self
        let message: Base64String = response.message
        let decodedMessage = message.decodeToLiteralString()
        guard let decodedMessageByte = decodedMessage?.data(using: .utf8) else {
            Log.d(message: "Unable to convert to byte")
            fatalError("Unable to convert to byte")
        }
        do {
            let payloadAndSignature = try JSONDecoder().decode(PS.self, from: decodedMessageByte)
            let payload = payloadAndSignature.payload
            let signature = payloadAndSignature.signature
            guard let signatureByte = Data(base64Encoded: signature) else {
                Log.d(message: "Error decoding base64 to data/byte array")
                fatalError("Error decoding base64 to data/byte array")
            }
            // Decrypt Signature
            guard let privateKey = AppStorageManager.getPrivateKeyData() else {
                Log.d(message: "No such private key")
                fatalError("No such private key")
            }
            guard let privateSecKey = TinggSecurity.dataToSecKey(privateKey, isPrivateKey: true) else {
                Log.d(message: "Error converting byte data to sec key")
                fatalError("Error converting byte data to sec key")
            }
            let decryptedSignature = try TinggSecurity.asymmetricDecrypt(signatureByte, privateKey: privateSecKey)
            let decryptedSignatureSplit = decryptedSignature.split(separator: ":")
            let secretkey: Base64String = String(decryptedSignatureSplit[0])
            let iv: Base64String = String(decryptedSignatureSplit[1])
            let result = TinggSecurity.symmetricDecrypt(ciphertextBase64: payload, secretKeyBase64: secretkey, ivBase64: iv)
            return result!
        } catch {
            return nil
        }
    }

    public func decodeToFinal<T: Decodable>() -> T? {
        Log.d(message: "Real json \(json)")
        do {
            let t: T = try decodeJSON(json)
            return t
        } catch {
            return nil
        }
    }
}

public struct PS: Codable {
    public let payload, signature: String

    enum CodingKeys: String, CodingKey {
        case payload = "PAYLOAD"
        case signature = "SIGNATURE"
    }
}

