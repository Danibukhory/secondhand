//
//  OffererViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit

final class OffererViewController: UITableViewController {
    
    var popupView: SHPopupView?
    
    enum OffererViewCellSectionType: Int {
        case offerer = 0
        case product = 1
    }
    
    private typealias sectionType = OffererViewCellSectionType
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        setupNavigationBar()
        setupPopupView()
        tableView.register(OffererDetailCell.self, forCellReuseIdentifier: "\(OffererDetailCell.self)")
        tableView.register(OffererProductCell.self, forCellReuseIdentifier: "\(OffererProductCell.self)")
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 1:
            return "Daftar produkmu yang ditawar"

        default:
            return nil
        }
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case sectionType.offerer.rawValue:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(OffererDetailCell.self)", for: indexPath
            ) as? OffererDetailCell else {
                return UITableViewCell()
            }
            cell.fill()
            cell.selectionStyle = .none
            return cell
            
        case sectionType.product.rawValue:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(OffererProductCell.self)", for: indexPath
            ) as? OffererProductCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.onRejectButtonTap = { [weak self] in
                guard let _self = self else { return }
                switch cell.rejectButton.currentAttributedTitle?.string {
                case "Tolak":
                    _self.popupView?.backgroundColor = .systemRed
                    UIView.animate(
                        withDuration: 0.5,
                        delay: 0,
                        usingSpringWithDamping: 0.7,
                        initialSpringVelocity: 18,
                        options: .layoutSubviews
                    ) {
                        _self.popupView?.layer.position.y = (_self.navigationController?.view.layoutMargins.top)!
                        if _self.popupView?.layer.position.y == (_self.navigationController?.view.layoutMargins.top)! {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                                    _self.popupView?.layer.position.y = -150
                                }
                            }
                        }
                    }
                case "Status":
                    let viewController = RenewTransactionStatusViewController()
                    viewController.changeDefaultHeight(to: (UIScreen.main.bounds.height / 2) - 60)
                    viewController.changeMaximumHeight(to: viewController.defaultHeight)
                    viewController.modalPresentationStyle = .overCurrentContext
                    viewController.onSendButtonTap = {
                        _self.popupView?.backgroundColor = UIColor(rgb: 0x73CA5C)
                        UIView.animate(
                            withDuration: 0.5,
                            delay: 0.5,
                            usingSpringWithDamping: 0.7,
                            initialSpringVelocity: 18,
                            options: .layoutSubviews
                        ) {
                            _self.popupView?.layer.position.y = (_self.navigationController?.view.layoutMargins.top)!
                            if _self.popupView?.layer.position.y == (_self.navigationController?.view.layoutMargins.top)! {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    UIView.animate(
                                        withDuration: 0.25,
                                        delay: 0,
                                        options: .curveEaseOut
                                    ) {
                                        _self.popupView?.layer.position.y = -150
                                    }
                                }
                            }
                        }
                    }
                    _self.tabBarController?.navigationController?.present(viewController, animated: false)
                default:
                    return
                }
            }
                
            cell.onAcceptButtonTap = {
                let viewController = OfferAcceptedViewController()
                let buyerCell = tableView.dequeueReusableCell(withIdentifier: "\(OffererDetailCell.self)") as! OffererDetailCell
                let productNameText = cell.productNameLabel.attributedText
                let productValueText = cell.offerValueLabel.attributedText
                buyerCell.fill()
                viewController.buyerImageView.image = buyerCell.offererImageView.image
                viewController.buyerNameLabel = buyerCell.offererNameLabel
                viewController.buyerCityLabel = buyerCell.offererCityLabel
                viewController.productImageView.image = cell.productImageView.image
                viewController.productNameLabel.attributedText = productNameText
                viewController.productValueLabel.attributedText = productValueText
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.changeDefaultHeight(to: (UIScreen.main.bounds.height / 2) + 30)
                self.tabBarController?.navigationController?.present(viewController, animated: false, completion: {
                    cell.rejectButton.setActiveButtonTitle(string: "Status")
                    cell.acceptButton.setActiveButtonTitle(string: "Hubungi")
                })
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 1:
            return
        default:
            return
        }
    }
    
    private func setupNavigationBar() {
        title = "Info Penawar"
    }
    
    private func setupPopupView() {
        popupView = SHPopupView(
            frame: CGRect(),
            popupType: .success,
            text: "Status produk berhasil diperbarui"
        )
        view.addSubview(popupView!)
        popupView?.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -100).isActive = true
        popupView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView?.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor).isActive = true
        popupView?.onDismissButtonTap = { [weak self] in
            guard let _self = self else { return }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                _self.popupView?.layer.position.y = -150
            }
        }
    }
    
    private func prepareCustomModalVC(viewController: SHModalViewController) {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

