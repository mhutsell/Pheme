//
//  KeyUtils.swift
//  StorageV1
//
//  Created by Ray Chen on 11/23/21.
//

import Foundation

func dataToPrivateKey(keyBody: Data) -> SecKey {
	let attribute = [
		kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
		kSecAttrKeyClass as String : kSecAttrKeyClassPrivate
	]
	var error: Unmanaged<CFError>?
	let priKey: SecKey = SecKeyCreateWithData(keyBody as CFData, attribute as CFDictionary, &error)!
	return priKey
}

// convert data to public key
func dataToPublicKey(keyBody: Data) -> SecKey {
	let attribute = [
		kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
		kSecAttrKeyClass as String : kSecAttrKeyClassPublic
	]
	var error: Unmanaged<CFError>?
	let pubKey: SecKey = SecKeyCreateWithData(keyBody as CFData, attribute as CFDictionary, &error)!
	return pubKey
}

// create public key called by createContact()
func stringToKeyBody(key: String) -> Data {
	return Data(base64Encoded: key, options: .ignoreUnknownCharacters)!
}

// encrypt string with public key and return the converted data
func encryptToData(publicKey: SecKey, msBody: String) -> Data {
	let bodyData: CFData = msBody.data(using: .utf8)! as CFData
	var error: Unmanaged<CFError>?
	let encryptedBody: Data = SecKeyCreateEncryptedData(publicKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256AESGCM, bodyData, &error)! as Data
	return encryptedBody
}


// decrypt body with private key and return the converted string
func decryptToString(privateKey: SecKey, body: Data) -> String {
	var error: Unmanaged<CFError>?
	let decryptedBody: Data = SecKeyCreateDecryptedData(privateKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256AESGCM, body as CFData, &error)! as Data
	return String(decoding: decryptedBody, as: UTF8.self)
}


