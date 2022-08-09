/** 
 * @description       : Override of the OmniScript Remote Action element to replace the button by an anchor link
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 09-16-2020
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-16-2021   Patrick THAI     Initial Version. html is based on omniscriptRemoteAction template from Summer '21
**/

import omniscriptRemoteAction from "vlocity_cmt/omniscriptRemoteAction";
import template from "./smOsRemoteActionLink.html";

export default class SmOsRemoteActionLink extends omniscriptRemoteAction {

    render() {
        return template;
    }
}