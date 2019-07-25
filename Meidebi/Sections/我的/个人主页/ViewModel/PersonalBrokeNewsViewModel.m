//
//  PersonalBrokeNewsViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalBrokeNewsViewModel.h"
#import "MDB_UserDefault.h"
@implementation PersonalBrokeNewsViewModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    PersonalBrokeNewsViewModel *viewModel = [[PersonalBrokeNewsViewModel alloc] init];
    [viewModel viewModelWithSubject:subject];
    return viewModel;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _artid=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _abroadhot=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"abroadhot"]]];
    _apilink_id=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"apilink_id"]]];
    _category=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"category"]]];
    _categoryname=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"categoryname"]]];
    _changetime=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"changetime"]]];
    _changeuser=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"changeuser"]]];
    _commentcount=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcount"]]];
    _contrysitename=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"contrysitename"]]];
    _cpsurl=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"cpsurl"]]];
    _descriptions=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"description"]]];
    _directtariff=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"directtariff"]]];
    _editforbiden=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"editforbiden"]]];
    _fcategory=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"fcategory"]]];
    _freight=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"freight"]]];
    _guoneihot=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"guoneihot"]]];
    _hit=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"hit"]]];
    _image=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"image"]]];
    _isabroad=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"isabroad"]]];
    _ishot=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"ishot"]]];
    _issendemail=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"issendemail"]]];
    _jibaoguoqi=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"jibaoguoqi"]]];
    _linktype=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"linktype"]]];
    _nickname=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"nickname"]]];
    _notchecked=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"notchecked"]]];
    _orginurl=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"orginurl"]]];
    _orginurl=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"orginurl"]]];
    _perfect=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"perfect"]]];
    _postage=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"postage"]]];
    _price=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"price"]]];
    _procurenum=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"procurenum"]]];
    _redirecturl=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"redirecturl"]]];
    _remoteimage=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"remoteimage"]]];
    _prodescription=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"prodescription"]]];
    _setahottime=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"setahottime"]]];
    _setthottime=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"setthottime"]]];
    _showcount=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"showcount"]]];
    _siteid=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"siteid"]]];
    _sitename=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"sitename"]]];
    _statustext=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"statustext"]]];
    _subsiteorwh=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"subsiteorwh"]]];
    _tagstr=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"tagstr"]]];
    _timeout=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"timeout"]]];
    _title=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"title"]]];
    _tmallhot=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"tmallhot"]]];
    _votesp=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"votesp"]]];
    _userid=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"userid"]]];
    _votesm=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"votesm"]]];
    _proprice=[NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"proprice"]]];
    NSDate *createtime=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"createtime"]] integerValue]];
    _createtime = [MDB_UserDefault CalDateIntervalFromData:createtime endDate:[NSDate date]];
    NSDate *setghottime=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"setghottime"]] integerValue]];
    _setghottime = [MDB_UserDefault CalDateIntervalFromData:setghottime endDate:[NSDate date]];
    NSDate *sethottime=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"sethottime"]] integerValue]];
    _sethottime = [MDB_UserDefault CalDateIntervalFromData:sethottime endDate:[NSDate date]];

    
    


}
@end
