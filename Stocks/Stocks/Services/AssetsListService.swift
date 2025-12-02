//
//  AssetsListService.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation

// TODO: Add protocol describing the service, force the dependables to use the abstraction

struct AssetsListService {
    var url = URL(string: "wss://ws.postman-echo.com/raw")!
    var stocks = [
        "AAPL", "GOOG", "TSLA", "AMZN", "MSFT", "NVDA", "META", "NFLX",
        "DIS", "BABA", "V", "JPM", "WMT", "JNJ", "MA", "PG", "UNH",
        "HD", "PYPL", "INTC", "CMCSA", "VZ", "ADBE", "PFE", "BAC"
    ]
    let stockDescriptions: [String: String] = [
        "AAPL": "Apple Inc. designs consumer electronics, software, and services such as iPhone, Mac, and iCloud.",
        "GOOG": "Alphabet Inc. (Google) focuses on internet services including Search, YouTube, Android, and cloud computing.",
        "TSLA": "Tesla, Inc. manufactures electric vehicles, energy storage products, and solar solutions.",
        "AMZN": "Amazon.com, Inc. is a global e-commerce and cloud computing company best known for Amazon Web Services (AWS).",
        "MSFT": "Microsoft Corporation develops software, cloud services (Azure), and products like Windows and Office.",
        "NVDA": "NVIDIA Corporation designs GPUs and chips powering gaming, data centers, and AI workloads.",
        "META": "Meta Platforms, Inc. operates social platforms like Facebook, Instagram, and WhatsApp, and invests in AR/VR.",
        "NFLX": "Netflix, Inc. is a subscription streaming service producing and distributing films and TV series worldwide.",
        "DIS": "The Walt Disney Company is an entertainment leader spanning studios, streaming, theme parks, and consumer products.",
        "BABA": "Alibaba Group is a Chinese technology company with major e-commerce platforms and cloud computing services.",
        "V": "Visa Inc. operates a global digital payments network enabling card and electronic transactions.",
        "JPM": "JPMorgan Chase & Co. is a major global bank providing consumer, investment, and commercial banking services.",
        "WMT": "Walmart Inc. is a multinational retailer operating hypermarkets, discount stores, and e-commerce platforms.",
        "JNJ": "Johnson & Johnson is a healthcare company focused on pharmaceuticals, medical devices, and consumer health products.",
        "MA": "Mastercard Incorporated runs a global payments network and provides payment technology and services.",
        "PG": "Procter & Gamble produces consumer goods across home, health, and personal care brands.",
        "UNH": "UnitedHealth Group is a healthcare and insurance provider with services through UnitedHealthcare and Optum.",
        "HD": "The Home Depot is a leading home improvement retailer serving DIY customers and professional contractors.",
        "PYPL": "PayPal Holdings provides digital payments services enabling online checkout, money transfers, and merchant solutions.",
        "INTC": "Intel Corporation designs and manufactures semiconductors, including CPUs for PCs and servers.",
        "CMCSA": "Comcast Corporation provides broadband, cable, media, and entertainment, including NBCUniversal units.",
        "VZ": "Verizon Communications is a telecom company offering wireless, broadband, and networking services.",
        "ADBE": "Adobe Inc. builds creative and document software like Photoshop and Acrobat, plus marketing tools.",
        "PFE": "Pfizer Inc. is a pharmaceutical company developing medicines and vaccines across multiple therapeutic areas.",
        "BAC": "Bank of America is a major financial institution offering consumer banking, wealth management, and investment services."
    ]
}
