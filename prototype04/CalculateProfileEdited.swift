//
//  CalculateProfileEdited.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/09/09.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import Foundation
import UIKit

class ProfileEdited{
    
    func calcurateRatio(status:Int)->Int{
        var count = 0
        var valueCount = 0
        
        switch status {
        case 1:
            let message = Recruiter().message
            if message != nil && message?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let position = Recruiter().position
            if position != nil && position?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let education = Recruiter().education
            if education != nil && education?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let ogori = Recruiter().ogori
            if ogori != nil && ogori?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let introduction = Recruiter().introduction
            if introduction != nil && introduction?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let skill = Recruiter().skill
            if skill != nil && skill?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            let feature = Recruiter().company_feature
            if feature != nil && feature?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let recruitment = Recruiter().company_recruitment
            if recruitment != nil && recruitment?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let population = Recruiter().company_population
            if population != nil{
                count += 1
            }
            valueCount += 1
            
            
            let industry = Recruiter().company_industry
            if industry != nil && industry?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let companyname = Recruiter().company_name
            if companyname != nil && companyname?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            
            
            let companylink = Recruiter().company_link
            if companylink != nil && companylink?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            
        case 2:
            
            let message = my().message
            if message != nil && message?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            let education = my().education
            if education != nil && education?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            let goodPoint = my().goodpoint
            if goodPoint != nil && goodPoint?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            let badPoint = my().badpoint
            if badPoint != nil && badPoint?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            let introduction = my().introduction
            if introduction != nil && introduction?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            
            let belonging = my().belonging
            if belonging != nil && belonging?.isEmpty == false{
                count += 1
            }
            valueCount += 1
            
            let interesting = my().interesting
            if interesting != nil && interesting?.isEmpty == false{
                count += 1
            }
            valueCount += 1
        default:
            break
        }
        return (count*100/valueCount)
    }
    
    
}
