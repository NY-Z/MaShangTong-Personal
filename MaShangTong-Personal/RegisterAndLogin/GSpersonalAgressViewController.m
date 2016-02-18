//
//  GSpersonalAgressViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/2/17.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSpersonalAgressViewController.h"

@interface GSpersonalAgressViewController ()

@end

@implementation GSpersonalAgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"码尚通企业服务协议";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSString *contentStr = @"法律声明及隐私政策\n\n法律声明\n\n访问、浏览或使用码尚通软件（包括“码尚通”信息服务平台、其附属发现功能及团购商城），以下统称“码尚通”，表明您已阅读、理解并同意接受以下条款的约束，并遵守所有适用的法律和法规。您一旦使用码尚通，则须秉着诚信的原则遵守以下条款。\n\n一般原则\n\n以下规则适用于所有码尚通用户或浏览者，码尚通可能随时修改这些条款。您应经常访问本页面以了解当前的条款，因为这些条款与您密切相关。这些条款的某 些条文也可能被码尚通软件中某些页面上或某些具体服务明确指定的法律通告或条款所取代，您应该了解这些内容，一旦接受本条款，即意味着您已经同时详细阅 读并接受了这些被引用或取代的条款。\n\n权利说明\n\n到位科技网络（上海）有限公司及其关联公司对其发行的或与合作公司共同发行的包括但不限于码尚通软件及相关产品或服务的全部内容，享有知识产权，受法律保护。如 果相关内容未含权利声明，并不代表码尚通对其不享有权利和不主张权利，您应根据法律、法规及诚信原则尊重权利人的合法权益并合法使用该内容。\n\n未经到位科技网络（上海）有限公司书面许可，任何单位及个人不得以任何方式或理由对上述软件、产品、服务、信息、文字的任何部分进行使用、复制、修改、抄录、传播 或与其它产品捆绑使用、销售,或以超级链路连接或传送、存储于信息检索系统或者其他任何商业目的的使用，但对于非商业目的的、个人使用的下载或打印（未作 修改，且须保留该内容中的版权说明或其他所有权的说明）除外。\n\n码尚通软件中使用和显示的商标和标识（以下统称“商标”）是到位科技网络（上海）有限公司及其关联公司注册和未注册的有关商标，受法律保护，但注明属于其他方拥 有的商标、标志、商号除外。码尚通软件中所载的任何内容，未经到位科技网络（上海）有限公司书面许可，任何人不得以任何方式使用码尚通名称及码尚通软件的商 标、标记。\n\n用户信息\n\n为码尚通提供相应服务之必须，您以自愿填写的方式提供注册所需的姓名、性别、电话以及其他类似的个人信息，则表示您已经了解并接受您个人信息的用途，同 意码尚通为实现该特定目的使用您的个人信息。除此个人信息之外，其他任何您发送或提供给码尚通的材料、信息或文本(以下统称信息)均将被视为非保密和 非专有的。码尚通对这些信息不承担任何义务。同时如果您提交时没有特别声明的，可视为同意码尚通及其授权人可以因商业或非商业的目的复制、透露、分发、合并和以其他方式利用这些信息和所有数据、图像、声音、文本及其他内容。您可阅读下面的码尚通隐私政策以了解更加详细的内容。\n\n责任限制声明\n\n不论在何种情况下，码尚通对由于信息网络设备维护、信息网络连接故障、智能终端、通讯或其他系统的故障、电力故障、罢工、劳动争议、暴乱、起义、骚乱、 火灾、洪水、风暴、爆炸、战争、政府行为、司法行政机关的命令、其他不可抗力或第三方的不作为而造成的不能服务或延迟服务不承担责任。\n\n无论在任何情况下（包括但不限于疏忽原因），由于使用码尚通上的信息或由码尚通软件链接的信息，或其他与码尚通软件链接的网站信息，对您或他人所造 成任何的损失或损害（包括直接、间接、特别或后果性的损失或损害，例如收入或利润之损失，智能终端系统之损坏或数据丢失等后果），均由使用者自行承担责任 （包括但不限于疏忽责任）。\n\n码尚通所载的信息，包括但不限于文本、图片、数据、观点、网页或链接，虽然力图准确和详尽，但码尚通并不就其所包含的信息和内容的准确、完整、充分和 可靠性做任何承诺。码尚通表明不对这些信息和内容的错误或遗漏承担责任，也不对这些信息和内容作出任何明示或默示的、包括但不限于没有侵犯第三方权利、 质量和没有智能终端病毒的保证。\n\n对于码尚通团购商城平台上所提及或展示的非码尚通产品或服务，码尚通仅提供基本信息。码尚通不是相关产品的生产者或经销者，亦不是服务的提供方。码尚通不就团购商城上提供的产品或服务做出任何声明或保证，所有展示的产品和服务应受其本公 司或服务提供方所做质量承诺和条款的约束。\n\n第三方链接\n\n码尚通可能保留有第三方网站或网址的链接，访问这些链接将由用户自己作出决定，码尚通并不就这些链接上所提供的任何信息、数据、观点、图片、陈述或建议的准确性、完整性、充分性和可靠性提供承诺或保证。码尚通没有审查过任何第三方网站， 对这些网站及其内容不进行控制，也不负任何责任。如果您决定访问任何与本站链接的第三方网站，其可能带来的结果和风险全部由您自己承担。\n\n适用法律和管辖权\n\n通过访问码尚通软件平台或使用码尚通提供的服务, 即表示您同意该访问或服务受中华人民共和国法律的约束，且您同意受中华人民共和国法院的管辖。访问或接受服务过程中发生的争议应当协商解决，协商不成的， 各方一致同意至到位科技网络（上海）有限公司住所所在地有管辖权的法院诉讼解决。\n\n隐私政策\n\n为向您提供更准确的个性化服务，在您使用码尚通产品或服务的过程中，我们可能会以如下方式收集和使用您提供的个人信息，本声明解释了这些情况下的信息收集和使用情况。码尚通非常重视对您的个人隐私保护，在您使用码尚通的产品及服务前，请您仔细阅读以下声明。\n\n我们收集以下信息\n\n地理位置信息及目的地信息；\n个人联系方式；\n对于司机类用户，我们会收集您的个人、车辆及行车信息，包括但不限于用户的姓名、公司信息、车辆行驶证信息、驾驶证信息，以及监督卡信息等；\n通过“码尚通”App完成的行程信息；\n其他根据具体服务的需要必要收集的信息。\n作为用户，您可根据您的意愿决定是否提供上述信息，同时，您可以查看您提供给我们的个人信息及行程信息；如果您希望删除或更正您的个人信息，请联系我们的客服人员。\n\n收集资料的方法\n\n码尚通将会收集及储存您在旗下产品客户端输入的资料，或通过其他渠道向我们提供的信息。我们亦会从关联公司、商业伙伴及其他独立第三方资料来源，获取与您有关并合法收集的个人或非个人资料；\n您在相关站点及其他供应商所作的隐私设定，可限制或阻止我们对有关资料的查阅；\n若您提供个人资料予我们，即表示您接受，码尚通将在所需期限内留存您的资料以履行有关用途，您的资料将在遵守适用相关法律及规定的情况下收集。\n\n收集个人资料可作以下用途\n\n提供码尚通产品中所包含的相关服务；\n到位科技网络（上海）有限公司网站及APP管理；\n用户身份验证、客户服务、安全防范、诈骗监测、存档和备份用途，确保我们向您提供的产品和服务的安全性；如果我们监测到您使用我们的服务用于欺诈或非法目的，我们将会相应采取措施停止服务；\n向您推送最新的市场信息及优惠方案；\n设计全新或改善目前所提供的产品及服务；\n服务内容个性化更新；\n协助执行法例、警方或其他政府或监管机构调查，以及遵守适用法律及规例所施行的规定，或其他向政府或监管机构承诺之义务；\n在收集之时所通知的其他用途；及与上述任何项目直接有关的其他用途。\n\n可能向您发送的信息\n\n为保证服务完成所必须的验证码；\n使用产品或服务时所必要的推送通知；\n当前用车费用优惠及减免信息；\n关于码尚通产品或服务的新闻、特别优惠及促销活动消息。\n\n信息安全及隐私保护措施\n\n到位科技网络（上海）有限公司及其关联公司采用严格的安全制度来确保我们收集的信息不丢失，不被滥用和变造；\n我们使用行业通行的安全技术和程序，来保护您的个人信息不被未经授权的访问、使用或泄露；\n为更好地提供服务升级产品，我们可能会将我们获得的数据提供给第三方用于分析统计。在提供服务的过程中，我们也会使用第三方的产品或服务。以上第三方企业或个人，只有在必须的情况下才会接触到用户信息，同时他们都受到严格的保密条款的约束；\n请注意，任何安全系统都存在可能的及未知的风险。\n\n变更\n\n随着码尚通服务的进一步提升，隐私声明的内容会随时更新。更新后的隐私声明一旦在网页上公布即有效代替原来的隐私声明。我们鼓励您定期查看本页以了解我们对于隐私保护的最新操作。";
    CGFloat height = [Helper heightOfString:contentStr font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-60];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:scrollView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH-60, height)];
    contentLabel.text = contentStr;
    //    contentLabel.backgroundColor = [UIColor cyanColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = RGBColor(123, 123, 123, 1.f);
    contentLabel.numberOfLines = 0;
    [scrollView addSubview:contentLabel];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+60);
    scrollView.showsVerticalScrollIndicator = NO;
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
