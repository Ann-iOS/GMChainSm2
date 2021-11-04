//
//  SegwitAddrCoder.swift
//  GMChainSm2
//
//  Created by iOS on 2021/11/2.
//

import UIKit
import HDWalletSDK

@objc
public class SegwitAddrCoder: NSObject {
    public static let shared = SegwitAddrCoder()
    private override init() {}

    /// Convert from one power-of-2 number base to another
    private func convertBits(from: Int, to: Int, pad: Bool, idata: Data) throws -> Data {
        var acc: Int = 0
        var bits: Int = 0
        let maxv: Int = (1 << to) - 1
        let maxAcc: Int = (1 << (from + to - 1)) - 1
        var odata = Data()
        for ibyte in idata {
            acc = ((acc << from) | Int(ibyte)) & maxAcc
            bits += from
            while bits >= to {
                bits -= to
                odata.append(UInt8((acc >> bits) & maxv))
            }
        }
        if pad {
            if bits != 0 {
                odata.append(UInt8((acc << (to - bits)) & maxv))
            }
        } else if (bits >= from || ((acc << (to - bits)) & maxv) != 0) {
            throw CoderError.bitsConversionFailed
        }
        return odata
    }


    /// Encode segwit address
    public func encode2(hrp: String, program: Data) throws -> String {
        let enc = try convertBits(from: 8, to: 5, pad: true, idata: program)
//        let result = bech32.encode(hrp, values: enc)
        let result = Bech32.encode(enc, prefix: hrp, seperator: "")
        return result
    }
}


extension SegwitAddrCoder {
    public enum CoderError: LocalizedError {
        case bitsConversionFailed
        case hrpMismatch(String, String)
        case checksumSizeTooLow

        case dataSizeMismatch(Int)
        case segwitVersionNotSupported(UInt8)
        case segwitV0ProgramSizeMismatch(Int)

        case encodingCheckFailed

        public var errorDescription: String? {
            switch self {
            case .bitsConversionFailed:
                return "Failed to perform bits conversion"
            case .checksumSizeTooLow:
                return "Checksum size is too low"
            case .dataSizeMismatch(let size):
                return "Program size \(size) does not meet required range 2...40"
            case .encodingCheckFailed:
                return "Failed to check result after encoding"
            case .hrpMismatch(let got, let expected):
                return "Human-readable-part \"\(got)\" does not match requested \"\(expected)\""
            case .segwitV0ProgramSizeMismatch(let size):
                return "Segwit program size \(size) does not meet version 0 requirments"
            case .segwitVersionNotSupported(let version):
                return "Segwit version \(version) is not supported by this decoder"
            }
        }
    }
}
