//
//  MainVC.swift
//  ToDO
//
//  Created by 김기현 on 2023/08/24.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    
    var ImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("동물 버튼", for: .normal)
        return button
        
    }()
    
    var TodoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("투두 리스트 입력!", for: .normal)
        
        
        return button
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        if let imageURL = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg"),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            imageView.image = image
        }
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(ImageButton)
        view.addSubview(TodoButton)
        view.addSubview(imageView)
        setupConstraints()
        
        TodoButton.addTarget(self, action: #selector(todoButtonTapped), for: .touchUpInside)
    }
    func setupConstraints() {
        ImageButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        TodoButton.snp.makeConstraints { make in
            make.top.equalTo(ImageButton).offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(ImageButton).offset(-300)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        
    }
    @objc func todoButtonTapped() {
        let vc = ViewController()
        navigationController?.pushViewController(vc, animated: true)
        print("눌럿다!")

    }
  }
   
    


