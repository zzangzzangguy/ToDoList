//
//  TodoCell.swift
//  ToDO
//
//  Created by 김기현 on 2023/08/24.
//

import UIKit
import SnapKit

class TodoCell: UITableViewCell {
    static let reuseIdentifier = "TodoCell"
    
    var TodoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.reuseIdentifier)
        self.cellSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cellSetting() {
        self.contentView.addSubview(self.TodoLabel)
        
        TodoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
