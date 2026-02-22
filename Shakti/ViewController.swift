//
//  ViewController.swift
//  Shakti
//
//  Created by Hitesh Kumar on 21/02/26.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI (built in code — no storyboard)
    private let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type something here…"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.returnKeyType = .done
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let updateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Update", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let outputLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "—"
        lbl.font = .systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        inputTextField.addTarget(self, action: #selector(returnKeyPressed), for: .editingDidEndOnExit)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)

        view.addSubview(inputTextField)
        view.addSubview(updateButton)
        view.addSubview(outputLabel)

        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            updateButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            outputLabel.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 24),
            outputLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            outputLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    // MARK: - Actions
    @objc private func returnKeyPressed() {
        updateLabel()
        inputTextField.resignFirstResponder()
    }

    @objc private func updateButtonTapped() {
        updateLabel()
        inputTextField.resignFirstResponder()
    }

    // MARK: - Helpers
    private func updateLabel() {
        outputLabel.text = inputTextField.text
    }
}

