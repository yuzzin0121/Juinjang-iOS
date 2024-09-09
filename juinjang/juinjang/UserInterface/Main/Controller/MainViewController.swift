import UIKit
import SnapKit
import Then
import Lottie
import Alamofire

final class MainViewController: BaseViewController, DeleteImjangListDelegate {
    
// MARK: - 변수, 상수 설정
    //설정 버튼, 메인 로고, 스피커 버튼
    var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named:"mainLogo")
    }
    
    //배경
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"backgroundshape")
        $0.alpha = 0.0
    }
    
    //테이블 뷰
    let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.id)
        $0.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.id)
    }
    
    var mainImjangList: [LimjangDto] = []
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultManager.shared.userStatus = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 710
        tableView.backgroundColor = .clear
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
       
        designNavigationBar()
        setConstraint()
        callMainImjangRequest()
    }
    
    func callMainImjangRequest() {
        //refreshToken()
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<RecentUpdatedDto>.self, api: .mainImjang) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                print(response)
                self.mainImjangList = result.recentUpdatedList
                self.tableView.reloadData()
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    func callVersionRequest(imjangId: Int, completion: @escaping (Int?) -> Void) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<DetailDto>.self, api: .detailImjang(imjangId: imjangId)) { detailDto, error in
            if error == nil {
                guard let result = detailDto else {
                    completion(nil)
                    return
                }
                if let detailDto = result.result {
                    let checkListVersion = detailDto.checkListVersion
                    if checkListVersion == "LIMJANG" {
                        completion(0)
                    } else if checkListVersion == "NON_LIMJANG" {
                        completion(1)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                guard let error else {
                    completion(nil)
                    return
                }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
                completion(nil)
            }
        }
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = mainLogoImageView
        
        // 이미지 로드
//        let speaker = UIImage(named:"speaker")
//
//        // UIBarButtonItem 생성 및 이미지 설정
//        let speakerButtonItem = UIBarButtonItem(image: speaker, style: .plain, target: self, action: nil)
//        speakerButtonItem.tintColor = ColorStyle.darkGray
//        speakerButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        
        let settingButtonItem = UIBarButtonItem(image: UIImage(named:"setting"), style: .plain, target: self, action: #selector(setttingBtnTap))
        settingButtonItem.tintColor = ColorStyle.darkGray
        settingButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = settingButtonItem
//        self.navigationItem.rightBarButtonItem = speakerButtonItem
    }
    
    func showImjangNoteVC(imjangId: Int?, version: Int?) {
        guard let imjangId = imjangId, let version = version else { return }
        let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .main
        imjangNoteVC.completionHandler = {
            self.callMainImjangRequest()
        }
        navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
    @objc func newImjangBtnTap() {
        let vc = OpenNewPageViewController()
        //let vc = ImjangNoteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func myImjangBtnTap() {
        let vc = ImjangListViewController()
        vc.deleteImjangListDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func setttingBtnTap() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setConstraint() {
        //배경
        backgroundImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(37.82)
            $0.height.equalTo(483.27)
            $0.left.equalToSuperview().offset(-201.08)
        }
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundImageView.alpha = 1.0
        }, completion: nil)
    
        //테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier, for: indexPath) as? TopTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
        
            cell.newImjangButton.addTarget(self, action: #selector(newImjangBtnTap), for: .touchUpInside)
            cell.myNoteButton.addTarget(self, action: #selector(myImjangBtnTap), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as? BottomTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.isHidden(mainImjangList.isEmpty)
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        } else {
            return BottomTableViewCell.cellHeight
        }
    }
}
     
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainImjangList.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = mainImjangList[indexPath.row]
        cell.configureCell(listDto: item)
        
        return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 143 , height: 204)
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = mainImjangList[indexPath.row]
        callVersionRequest(imjangId: item.limjangId) { version in
            if let version = version {
                self.showImjangNoteVC(imjangId: item.limjangId, version: version)
            } else {
                self.showImjangNoteVC(imjangId: item.limjangId, version: version)
            }
        }
    }
    
    func deleteImjangList(_ deleteIdList: [Int]) {
        mainImjangList.removeAll { imjang in
            deleteIdList.contains(imjang.limjangId)
        }
        tableView.reloadData()
    }
}

