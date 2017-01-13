
function updateTipOptionsForMode(tip_options,show_mode) {
  switch(show_mode) {
    case 2:
      tip_options['hideTrigger']='closeButton';
      tip_options['fixed']=true;
      break;
    case 3:
      tip_options['hideTrigger']='tip';
      tip_options['hideOn']='mouseout';
      tip_options['fixed']=true;
      break;
  }
}


function addTooltipsToAttachColumn() {
  var attach_list=$$('.pac_field_preview_attached');
  var children;
  var i,j;
  var res_str,tip_str;

  for(i=0;i<attach_list.length;i++) {
    res_str='';
    children=attach_list[i].childElements();
    for(j=0;j<children.length;j++) {
      tip_str=children[j].readAttribute('opentiptitle');
      if(tip_str!=null)
      {
        if(res_str != '') {
          res_str+="<br/>";
        }
        res_str+=tip_str;
      }
    }
    if(res_str != '') {
      attach_list[i].addTip(res_str, '', { });
    }
  }
}

function addTooltipsToIssues(ajax_url,show_mode_str,appear_delay) {
  var issues_list=$$("tr[id^='issue-']");
  var children;
  var i,id;
//  var at=$$('input[name="authenticity_token"]').first().value;
  var tip_options;
  var show_mode=parseInt(show_mode_str);

// issues list
  for(i=0;i<issues_list.length;i++) {
    children=issues_list[i].select("td[class='subject']");
    if(children.length > 0) {
      id=issues_list[i].readAttribute("id").match(/^issue\-([0-9]+)$/);
      if( id && id.length >1 ) {
        tip_options={
          delay : parseFloat(appear_delay),
          group: 'issuestips',
          ajax: { url: ajax_url+'/'+id[1]}
        };
        updateTipOptionsForMode(tip_options,show_mode);
        children.first().addTip(tip_options);
      }
    }
  }

// gantt
  issues_list=$$("div[class='issue-subject']");
  for(i=0;i<issues_list.length;i++) {
    children=issues_list[i].select('a');
    if(children.length > 0) {
      id=children.first().href.match(/^(.+)\/([0-9]+)$/);
      if( id && id.length >2 ) {
        tip_options={
          delay : parseFloat(appear_delay),
          group: 'issuestips',
          offset: [0,30],
          ajax: { url: ajax_url+'/'+id[2]}
        };
        updateTipOptionsForMode(tip_options,show_mode);
        children.first().addTip(tip_options);
      }
    }
  }

}
