//
//  BookingViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingViewController: ViewController {
    
    struct HeaderInformation {
        var dayOfWeek: String
        var date: String
        var fromStation: String
        var fromTime: String? = nil
        var toStation: String
        var toTime: String? = nil
        var trainNumber: String? = nil
        var trainName: String? = nil
        var carNumber: String? = nil
        var className: String? = nil
        var seatNumber: String? = nil
        var price: String? = nil
        
        init(dayOfWeek: String, date: String, fromStation: String, toStation: String) {
            self.dayOfWeek = dayOfWeek
            self.date = date
            self.fromStation = fromStation
            self.toStation = toStation
            fromTime = nil
            toTime = nil
            trainNumber = nil
            trainName = nil
            carNumber = nil
            className = nil
            seatNumber = nil
            price = nil
        }
    }
    
    enum MainViewType {
        case tableView
        case view
    }
    
    var headerInformation: HeaderInformation? {
        didSet {
            setHeaderInformationValue(headerInformation)
        }
    }
    
    var mainViewType: MainViewType = .tableView {
        didSet {
            switch mainViewType {
            case .tableView:
                mainTableView.isHidden = false
                mainContentView.isHidden = true
                mainCallToActionButton.isHidden = true
            case .view:
                mainTableView.isHidden = true
                mainContentView.isHidden = false
                mainCallToActionButton.isHidden = false
            }
        }
    }
    
    var isPopPerforming: Bool = false {
        didSet {
            if oldValue != isPopPerforming && isPopPerforming == true {
                navigationController?.popViewController(animated: true)
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
    
    var mainCallToActionButton: Button!
    
    var mainStackView: UIStackView!
    
    var topBarStackView: UIStackView!
    
    var headerWithTopBarStackView: UIStackView!
    
    var backButton: BackButtonControl!
    
    private var datePlaceholderLabelSetView: DateLabelSetView!
    
    var dateLabelSetView: DateLabelSetView!
    
    var headerRouteInformationView: HeaderRouteInformationView!
    
    var mainContentView: UIView!
    
    var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        // MARK: Header
        datePlaceholderLabelSetView = DateLabelSetView(dayOfWeek: " ", date: " ")
        dateLabelSetView = DateLabelSetView(dayOfWeek: " ", date: " ")
        topBarStackView = UIStackView([datePlaceholderLabelSetView, dateLabelSetView],
                                          axis: .horizontal,
                                          distribution: .equalSpacing,
                                          alignment: .center)
        
        headerRouteInformationView = HeaderRouteInformationView(fromStation: " ", toStation: " ")
        
        headerWithTopBarStackView = UIStackView([topBarStackView, headerRouteInformationView],
                                                axis: .vertical,
                                                distribution: .fill,
                                                alignment: .fill,
                                                spacing: 20)
        
        let headerWithTopBarContainerView = UIView(containingView: headerWithTopBarStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin, .bottom])
        
        headerWithTopBarContainerView.preservesSuperviewLayoutMargins = true
        
        mainContentView = UIView()
        mainContentView.preservesSuperviewLayoutMargins = true
        mainContentView.backgroundColor = .clear
        mainContentView.isHidden = true
        
        mainTableView = UITableView(frame: .zero, style: .plain)
        mainTableView.preservesSuperviewLayoutMargins = true
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.backgroundColor = .clear
        mainTableView.separatorStyle = .none
        mainTableView.contentInset.top = 12
        mainTableView.contentOffset.y = -12
        mainTableView.delegate = self
        
        mainStackView = UIStackView([headerWithTopBarContainerView, mainContentView, mainTableView],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .fill,
                                    spacing: 20)
        mainStackView.preservesSuperviewLayoutMargins = true
        
        view.addSubview(mainStackView, withConstaintEquals: .edges)
        
        // MARK: Setup Button
        mainCallToActionButton = Button(type: .contained)
        view.addSubview(mainCallToActionButton, withConstaintEquals: [.leadingMargin, .trailingMargin])
        view.constraintBottomSafeArea(to: mainCallToActionButton, withMinimumConstant: 16)
        
        backButton = BackButtonControl()
        view.addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: topBarStackView.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: topBarStackView.leadingAnchor, constant: -10).isActive = true
        
        setHeaderInformationValue(headerInformation)
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        mainCallToActionButton.setupTheme()
        backButton.setupTheme()
        dateLabelSetView.setupTheme()
        datePlaceholderLabelSetView.setupTheme()
        headerRouteInformationView.setupTheme()
        mainTableView.setupTheme()
        
    }
    
    override func setupInteraction() {
        super.setupInteraction()
    }
    
    func setHeaderInformationValue(_ headerInformation: HeaderInformation?) {
        guard let headerInformation = headerInformation,
            let dateLabelSetView = dateLabelSetView,
            let headerRouteInformationView = headerRouteInformationView else { return }
        dateLabelSetView.setupValue(dayOfWeek: headerInformation.dayOfWeek,
                                    date: headerInformation.date)
        headerRouteInformationView.setupValue(fromStation: headerInformation.fromStation,
                                              fromTime: headerInformation.fromTime,
                                              toStation: headerInformation.toStation,
                                              toTime: headerInformation.toTime,
                                              trainNumber: headerInformation.trainNumber,
                                              trainName: headerInformation.trainName,
                                              carNumber: headerInformation.carNumber,
                                              className: headerInformation.className,
                                              seatNumber: headerInformation.seatNumber,
                                              price: headerInformation.price)
    }
    
}

extension BookingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalContentOffset = scrollView.contentOffset.y + scrollView.contentInset.top
       
        if !isPopPerforming {
            headerRouteInformationView.verticalRubberBandEffect(byVerticalContentOffset: verticalContentOffset)
            let translateX = verticalContentOffset <= 0 ? -verticalContentOffset / 6 : 0
            backButton.shapeView.transform.tx = translateX
            if verticalContentOffset < 0  {
                backButton.shapeLayer.removeAnimation(forKey: "ActualAnimation")
            }
            backButton.setShapeProgress(to: verticalContentOffset < 0 ? CFTimeInterval(-verticalContentOffset / 128) : 0)
        }
        
        if verticalContentOffset < -128 {
            isPopPerforming = true
        }
        
    }
}
