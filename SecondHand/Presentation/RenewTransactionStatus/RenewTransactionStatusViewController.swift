//
//  RenewTransactionStatusViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 23/06/22.
//

import UIKit

final class RenewTransactionStatusViewController: SHModalViewController {
    
    var handleBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC4C4C4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle(
            text: "Perbarui status penjualan produkmu",
            size: 14,
            weight: .medium,
            color: .black
        )
        label.numberOfLines = 0
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var sendButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Kirim", type: .filled, size: .regular)
        button.isEnabled = false
        button.addTarget(Any.self, action: #selector(sendNewStatus), for: .touchUpInside)
        return button
    }()
    
    var isCanceled: Bool = false
    
    typealias OnSendButtonTap = () -> Void
    var onSendButtonTap: OnSendButtonTap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        prepareTableView()
        defineLayout()
    }
    
    private func addSubviews() {
        containerView.addSubviews(handleBar, titleLabel, tableView, sendButton)
    }
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionStatusCell.self, forCellReuseIdentifier: "\(TransactionStatusCell.self)")
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
    }
    
    private func defineLayout() {
        let margin = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            handleBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            handleBar.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            handleBar.heightAnchor.constraint(equalToConstant: 6),
            handleBar.widthAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),
            
            sendButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -64),
            sendButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            sendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    @objc private func sendNewStatus() {
        self.animateDismissView()
        onSendButtonTap?()
    }
    
}

extension RenewTransactionStatusViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(TransactionStatusCell.self)",
            for: indexPath
        ) as? TransactionStatusCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        switch row {
        case 0:
            cell.statusLabel.setTitle(
                text: "Berhasil terjual",
                size: 14,
                weight: .regular,
                color: .black
            )
            cell.statusDetailLabel.setTitle(
                text: "Kamu telah sepakat menjual produk ini kepada pembeli.",
                size: 14,
                weight: .regular,
                color: UIColor(rgb: 0x8A8A8A)
            )
            
        case 1:
            cell.statusLabel.setTitle(
                text: "Batalkan transaksi",
                size: 14,
                weight: .regular,
                color: .black
            )
            cell.statusDetailLabel.setTitle(
                text: "Kamu membatalkan transaksi produk ini dengan pembeli.",
                size: 14,
                weight: .regular,
                color: UIColor(rgb: 0x8A8A8A)
            )
            
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TransactionStatusCell else { return }
        let row = indexPath.row
        if row == 1 {
            isCanceled = true
        } else {
            isCanceled = false
        }
        cell.selected()
        sendButton.isEnabled = true
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TransactionStatusCell else { return }
        cell.deselected()
    }
    
}
