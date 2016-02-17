//
//  GSsoftwareMaintenanceViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/2/16.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSsoftwareMaintenanceViewController.h"

@interface GSsoftwareMaintenanceViewController ()

@end

@implementation GSsoftwareMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"码尚通软件服务协议";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSString *contentStr = @"欢迎使用”码尚通”企业服务本协议由甲方（企 业级专车用户）和乙方（到位网络科技（上海）有限公司）通过电子合同形式签订，甲方在线点击注册成为乙方企业级专车用户时，应阅读并同意本电子合同内容。 甲方点击注册乙方企业级专车账户的时间作为本电子合同的生效时间。甲方可随时查阅也可选择下载本电子合同文本内容。\n1. 服务形式及服务规则\n1.1 服务形式甲方可通过”码尚通”企业端预约专车服务。甲方乘车人员在行程结束后无需支付用车费及增值服务费，相应金额将自动 从企业帐户余额中扣除。乙方根据甲方需求，还可提供车辆呼叫中心、专属VIP客服、企业结算统一对帐及实时管理用车信息等增值服务。乙方保留对各项功能升 级及新增功能调整收费标准的权利。\n1.2 服务期限:自本协议生效之日起一年。\n1.3 价格及支付\n\t（1）签约三日内甲方通过乙方【”码尚通”企业版】网站（网址【www.51mast.com】）以 线上支付的方式向乙方预存第一笔车费不少于人民币1000元及本条第。\n\t（2）项约定的增值服务费。本合同载明的乙方线上充值网站为本合同唯一的支付途径，甲 方知悉并同意不会向其他任何账户支付本合同项下的付款，如网站信息发生变化，乙方应通过书面形式通知甲方。如服务期限内充值金额未使用完毕，余额将转作下 一期服务费或用于购买乙方的其他产品及/或服务，对此乙方应向甲方提供相应的配合。\n\t（1）上述费用的开票方式为：收到本条第。\n\t（2）项约定的款项后15个工作日内，乙方为甲方开具全额发票。甲方账户中的预存款，只能用于支付专车服务费；甲方乘车人员使用企业端选择出租车服务的，由乘车人员支付车费，车费发票由提供相应服务的出租车驾驶员提供。\n\t（3）乙方专车服务计价方式以乙方实时公布的价格表为准，甲方可随时向乙方索取该价格表的最新版本。\n\t（4）如果甲方未能按乙方提示充值导致甲方帐号内余额不足200元时，乙方有权中止支持甲方使用企业帐号发出的叫车服务。\n\t（5）甲方可随时向其企业帐号充值车费，乙方依据本条第（3）项约定的方式，向甲方开具相应发票。\n\t（6）如果甲方采购了乙方的增值结算服务且甲方已支付了服务费，应甲方要求乙方应提供与甲方使用企业帐号有关的如下信息，用于甲方内部财务核算之目的：\n\t- 乘车人起始到达地信息；\n\t- 用车费信息；\n\t- 用车时间信息。\n2. 责任限制在法律允许的情况下，因本协议而产生的或与本协议有关的乙方的责任不应超过甲方依照本协议支付的合同价款总额。\n3. 数据所有权乙方承认甲方数据现在且将来均属于甲方财产。\n4. 保证与承诺乙方声明并保证：\n\t(a) 其为依照公司设立地的法律规定设立并合法存续的公司；\n\t(b) 其已采取所有必要措施取得本协议的签署、交付及履行的授权；\n\t(c) 为甲方提供服务的车辆都来自有合法资质的车辆出租公司；\n\t(d) 为甲方提供车辆驾驶服务的人员都来自有合法资质的劳务服务公司；\n\t(e) 其有权签订并履行本协议项下的义务，并且无需任何其他人的同意；并且\n\t(f) 服务条款或甲方对服务的使用不会侵犯任何第三方的知识产权；\n5. 终止在下述情况下，任何一方（以下简称“第一方”）均可在书面通知另一方后立即终止本协议：\n\t(a) 另一方停业、清算（事先得到第一方书面同意的、为善意破产的重建或合并之目的而进行的自愿清算除外）或解散；\n\t(b) 另一方无法支付到期债务，或其全部或部分财产被指定给破产接管人、行政接管人或管理人（或依照其公司所在地或公司设立地的法律规定的任何类似官员或程序）接管，或正面临任何破产程序；\n\t(c) 另一方违反本协议的规定，并且在第一方指出违约后 30 日内未采取任何补救措施（其有能力采取补救措施的）；或\n\t(d) 另一方违约，并且该等违约无法补救。\n6. 保密\n6.1 未经另一方事先书面许可，一方在任何情况下均不得将另一方的机密信息泄漏给第三方。\n6.2 尽管前款规定，乙方可向其职员、顾问及供应商透露机密信息，前提是该种透露应为乙方履行本协议之义务所必需，且上述职员、顾问及供应商同意承担与本协议中所规定的保密义务相同或更严格的保密义务。\n6.3 为本协议之目的，“机密信息”是指与一方有关、被其指定为机密的任何信息，或是另一方应合理认定为机密的任何信息。机密信息包括但不限于甲方名单以及与一方业务有关的、另一方以任何方式占有或了解的各种信息及材料，但不包括下列内容：\n\t(a) 接受方在从另一方接受之前就已经拥有的信息和材料；\n\t(b) 一方从第三方合法获得的无需承担保密义务的信息和材料；\n\t(c) 非因接受方违反保密义务，当前或之后为公众所知的信息和材料；\n\t(d) 未接触另一方机密信息的接受方开发人员独自开发的信息和材料；或\n\t(e) 经接受信息一方书面授权公开或书面指定为不再保密或不再专有的任何信息或材料。\n7. 不可抗力\n7.1 任何一方因其无法预见或虽能预见但无法避免的原因，包括但不限于战争、火灾、封锁、罢工、黑客攻击、电脑病毒、运营商服务中断或自然灾害而导致其无法履行协议项下的义务时，该方对另一方因上述不履行而导致的损失或损害不承担责任。\n7.2 如果乙方连续 [30] 天（或在任何一个 60 天的期限内合计超过 30 天）无法充分履行其责任，甲方可以在发出书面通知 30 天后终止本协议或终止受该因素影响的部分。\n7.3 一方在知道可能导致不可抗力的事件发生时应立即通知另一方。\n8. 关系\n8.1 本协议中任何条款均不会在各方之间建立合资、合伙或代理关系。同样，除非本协议明确授权，任何一方均无权代表另一方进行抵押贷款、做出任何声明或授权签约。\n8.2 乙方的任何职员均不得仅依本协议或因履行本协议项下乙方的义务而被视为甲方的雇员。\n9. 弃权\n9.1 任何一方在执行本协议规定时的容忍、迟延或放纵不应限制或影响该方的权利，因违反本协议约定而对权利的放弃不得视为对之后其他违约权利的放弃。\n9.2 一方依照本协议所获得或保有的任何权利、权力或救济均不排除该方所拥有的其他权利、权力或救济的适用，并可同时适用上述各项权利、权力或救济。\n10. 转让与分包\n10.1 未经他方事先书面同意（无正当理由时不得拒绝或拖延），任何一方均不得将其在本协议项下的任何权利或义务转让或分包给任何第三方。\n10.2 如甲方允许乙方将其协议下的部分义务进行分包，乙方保证分包商像乙方一样履行本协议项下的义务。\n11. 完整协议本协议及其附件以及乙方网站的使用条款构成各方就协议标的所达成的全部约定及谅解。除非本协议另有明确说明，取代并废除各方在此之前所达成的所有口头或书面协议、声明、陈述、谅解、谈判及讨论。\n12. 适用法律及诉讼管辖区本协议以及与本协议有关的任何事项均应由[中国]法律的管辖及解释。与本协议有关的一切争议均应提交有管辖权的人民法院以诉讼方式解决。\n13. 文本及效力本协议自甲方点击注册成为乙方企业级专车用户的时间起生效。";
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
