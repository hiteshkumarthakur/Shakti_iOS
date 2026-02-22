//
//  WebViewController.swift
//  Shakti
//
//  Created by Hitesh Kumar on 22/02/26.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - UI (built in code — no storyboard)
    private let urlTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter URL (e.g. https://example.com)"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.returnKeyType = .go
        tf.keyboardType = .URL
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let goButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Go", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()

    /// Set by SceneDelegate before the view loads (cold-start deep link).
    var pendingURL: URL?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()

        if let pending = pendingURL {
            loadURL(pending)
            pendingURL = nil
        } else {
            loadURL(URL(string: "https://www.google.com")!)
        }
    }

    // MARK: - Setup
    private func setupUI() {
        urlTextField.addTarget(self, action: #selector(returnKeyPressed), for: .editingDidEndOnExit)
        goButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)

        view.addSubview(urlTextField)
        view.addSubview(goButton)
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: goButton.leadingAnchor, constant: -8),

            goButton.centerYAnchor.constraint(equalTo: urlTextField.centerYAnchor),
            goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goButton.widthAnchor.constraint(equalToConstant: 55),

            webView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Public Interface (called by SceneDelegate)
    func loadURL(_ url: URL) {
        guard isViewLoaded else { pendingURL = url; return }
        urlTextField.text = url.absoluteString
        webView.load(URLRequest(url: url))
    }

    // MARK: - Actions
    @objc private func returnKeyPressed() {
        loadFromTextField()
        urlTextField.resignFirstResponder()
    }

    @objc private func loadButtonTapped() {
        loadFromTextField()
        urlTextField.resignFirstResponder()
    }

    // MARK: - Helpers
    private func loadFromTextField() {
        guard var raw = urlTextField.text, !raw.isEmpty else { return }
        if !raw.hasPrefix("http://") && !raw.hasPrefix("https://") {
            raw = "https://" + raw
            urlTextField.text = raw
        }
        guard let url = URL(string: raw) else {
            let alert = UIAlertController(title: "Invalid URL",
                                          message: "'\(raw)' is not a valid URL.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        webView.load(URLRequest(url: url))
    }
}
