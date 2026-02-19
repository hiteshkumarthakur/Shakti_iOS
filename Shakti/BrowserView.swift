//
//  BrowserView.swift
//  Shakti
//
//  Created by Hitesh Kumar on 19/02/26.
//

import SwiftUI
import WebKit

// MARK: - WKWebView wrapper

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var errorMessage: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: Navigation delegate

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            parent.errorMessage = error.localizedDescription
        }

        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            parent.errorMessage = error.localizedDescription
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.errorMessage = nil
        }
    }
}

// MARK: - Browser tab view

struct BrowserView: View {
    @State private var inputText: String = ""
    @State private var loadedURL: URL? = nil
    @State private var validationError: String? = nil
    @State private var webLoadError: String? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // URL input bar
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        TextField("https://example.com", text: $inputText)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Button("Load") {
                            loadURL()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    if let error = validationError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }

                    if let error = webLoadError {
                        Text("Load error: \(error)")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 8)

                Divider()

                // Web view area
                if let url = loadedURL {
                    WebView(url: url, errorMessage: $webLoadError)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "safari")
                            .font(.system(size: 52))
                            .foregroundColor(.secondary)
                        Text("Enter a URL above and tap Load")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Browser")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func loadURL() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            validationError = "Please enter a URL."
            return
        }

        guard trimmed.lowercased().hasPrefix("http://") ||
              trimmed.lowercased().hasPrefix("https://") else {
            validationError = "URL must start with http:// or https://"
            return
        }

        guard let url = URL(string: trimmed) else {
            validationError = "Invalid URL format."
            return
        }

        validationError = nil
        webLoadError = nil
        loadedURL = url
    }
}

#Preview {
    BrowserView()
}
