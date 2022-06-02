//
//  QRCell.swift
//  qr-station
//
//  Created by Petr Sedlák on 23.05.2022.
//

import UIKit

class QRCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var whereFromLbl: PaddingLabel!
    @IBOutlet weak var favoriteImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contentLbl: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleText.numberOfLines = 0
        dateLbl.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        dateLbl.textColor = .secondaryLabel
        titleText.textColor = .label
        titleText.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        whereFromLbl.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        whereFromLbl.textColor = .white
        contentLbl.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        contentLbl.textColor = .white
        qrImage.layer.cornerRadius = 4
        favoriteImg.image = UIImage(systemName: "star.square.fill")
        favoriteImg.tintColor = .systemYellow
        nameLbl.numberOfLines = 0
        nameLbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    func setupCell(with qr: QRProtocol) {
        titleText.text = qr.string
        dateLbl.text = qr.formattedDate
        qrImage.image = qr.qr
        whereFromLbl.backgroundColor = qr.whereFrom.color
        whereFromLbl.text = qr.whereFrom.detail
        whereFromLbl.layer.masksToBounds = true
        whereFromLbl.layer.cornerRadius = 5
        contentLbl.backgroundColor = qr.content.color
        contentLbl.text = qr.content.description
        contentLbl.layer.masksToBounds = true
        contentLbl.layer.cornerRadius = 5
        favoriteImg.isHidden = !qr.isFavorite
        nameLbl.text = qr.name
        nameLbl.isHidden = qr.name.isEmpty
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
