//
//  KPDatePickerBottomSheet.swift
//  SimplePhotoApp
//
//  Created by jc.kim on 4/25/23.
//

import UIKit

final class PhotoPickerBottomSheet: UIViewController {
  
  // MARK: - Views

  private let backgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    view.alpha = 0
    return view
  }()
  
  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(pop))
    return tapGesture
  }()
  
  private let bottomSheetView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .tertiarySystemBackground
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 25
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.layer.cornerCurve = .continuous
    return view
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 20
    stackView.alignment = .fill
    return stackView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .left
    label.text = "앨범 선택"
    label.textColor = .label
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    return label
  }()
  
  private lazy var pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    pickerView.dataSource = self
    pickerView.delegate = self
    return pickerView
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(
      UIImage(systemName: "xmark.circle",
              withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal
    )
    button.addTarget(self, action: #selector(pop), for: .touchUpInside)
    button.tintColor = .label
    return button
  }()
  
  private lazy var alertActionButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("확인", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 25
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    return button
  }()
  
  private let safeAreaInsetsBottomView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBackground
    return view
  }()
  
  // MARK: - Properties
  
  private var selectedIndex = 0
  
  var pickerValueChange: (Int) -> Void = { _ in }
  
  private let albums: [AlbumInfo]

  init(albums: [AlbumInfo]) {
    self.albums = albums
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.albums = []
    super.init(coder: coder)
  }
  
  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    showBackgroundView()
  }
  
  // MARK: - Methods

  private func showBackgroundView() {
    UIView.animate(withDuration: 0.25) { self.backgroundView.alpha = 0.6 }
  }
  
  private func setupViews() {
    view.addSubview(backgroundView)
    view.addSubview(bottomSheetView)
    view.addSubview(closeButton)
    
    backgroundView.frame = view.bounds
    backgroundView.addGestureRecognizer(tapGestureRecognizer)
    
    bottomSheetView.addSubview(stackView)
    
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(pickerView)
    stackView.addArrangedSubview(alertActionButton)
    stackView.addArrangedSubview(safeAreaInsetsBottomView)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
      closeButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20),
      
      bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      stackView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
      stackView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
        
      alertActionButton.heightAnchor.constraint(equalToConstant: 50),
      safeAreaInsetsBottomView.heightAnchor.constraint(equalToConstant: UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
    ])
  }
    
  @objc
  private func pop() {
    backgroundView.alpha = 0
    dismiss(animated: true)
  }
  
  @objc
  private func confirm() {
    pickerValueChange(selectedIndex)
    pop()
  }
  
}

// MARK: - Picker

extension PhotoPickerBottomSheet: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return albums.count
  }
  
}

extension PhotoPickerBottomSheet: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return albums[row].name + "(\(albums[row].count))"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.selectedIndex = row
  }
  
}
