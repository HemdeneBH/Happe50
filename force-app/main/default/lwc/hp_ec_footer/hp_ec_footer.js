/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-24-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
import { LightningElement, track, api, wire} from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/HP_EC_variables';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import getContentList from '@salesforce/apex/HP_EC_ManageContent.getContentList';
import basePath from '@salesforce/community/basePath';

// import HP_EC_facebook from '@salesforce/resourceUrl/HP_EC_facebook';
// import HP_EC_twitter from '@salesforce/resourceUrl/HP_EC_twitter';
// import HP_EC_insta from '@salesforce/resourceUrl/HP_EC_insta';
// import ReminderDateTime from '@salesforce/schema/Task.ReminderDateTime';

export default class Hp_ec_footer extends LightningElement {

    blogs;
    maxEntries = 9;

    connectedCallback() {
        loadStyle(this, styles);
    }

    @api copyrightMention;
    @api contentLegals;
    @api mentionLabel;
    @api lienMention;
    @api label;
    @api lienCGV;
    @api socialNetworks;
    @api theme;
    @api tagCommander;
    @api uploadedImage;


    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        if (this.tagCommander) {
            loadScript(this, this.tagCommander)
            .catch(error=>{
                console.log('Failed to load the tagCommander : ' +error);
            });
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
      switchTheme.call(this, styleName);
    }

    @wire(getContentList, {
        page: 0,
        pageSize: '$maxEntries',
        language: 'fr',
        filterby: 'cms_image'
    })
    wiredContent({ data, error }) {
        if (data) {
            this.blogs = data.map((entry) => ({
                key: entry.contentKey,
                title: entry.contentNodes.title.value,
                imageUrl: `${basePath}/sfsites/c${entry.contentNodes.source.unauthenticatedUrl}`,
                imageAltText: entry.contentNodes.source.fileName,
                url: (entry.contentNodes.thumbUrl != undefined) ? entry.contentNodes.thumbUrl.value : '',
                publishedDate: entry.publishedDate
            }));
            if(this.blogs.length > 5){
                this.blogs = this.extractLastFiveEcone(this.blogs);
            }
            
            this.error = undefined;
        }
        if (error) {
            console.log('Error: footer ' + JSON.stringify(error));
        }
    }   

    extractLastFiveEcone(tabEcone){
        let placeIDs = [];
        tabEcone.sort(function(a, b) {
            return new Date(b.publishedDate) - new Date(a.publishedDate);
        })
        
        tabEcone.slice(0, 5).map((item, i) => {
            placeIDs.push(item);
            });
        return placeIDs;
        
    }


}