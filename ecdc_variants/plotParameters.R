getPalette <- function(palName){
  
  colOther <- gray(0.5)
  colUnknown <- gray(0.8)
  
  if(palName == "Nextstrain"){
    colAlpha <- "#1f1dff"
    colBeta <- "#6322b9"
    colGamma <- "#4760e9"
    colDelta <- "#66babf"
    colOmicron <- "#f55c30"
  }
  
  # Colors SPF - from the weekly epidemiological reports
  # e.g., https://t.co/eFu2Jdt3j1
  if(palName == "SPF"){
    colAlpha <- "#de2f1e"
    colBeta <- "#ff7340"
    colGamma <- "#f6b756"
    colDelta <- "#fdde8b"
    colOmicron <- "#c7eae4"
    colOther <- gray(0.9)
  }
  
  # Colors from the MetBrewer package
  if(palName == "Isfahan2"){
    colOmicron <- "#DBBC20" 
    colDelta <- "#A1B427" 
    colGamma <- "#5DB076" 
    colBeta <- "#36A5BF" 
    colAlpha <- "#4063A3"
  }
  
  if(palName == "Moreau"){
    colAlpha <- "#421600" 
    colBeta <- "#792504" 
    colGamma <- "#bc7524" 
    colDelta <- "#8dadca" 
    colOmicron <- "#104839"
  }
  
  if(palName == "Signac"){
    colAlpha <- "#f4c40f" 
    colBeta <- "#fe9b00" 
    colGamma <- "#d8443c" 
    colDelta <- "#de597c" 
    colOmicron <- "#1f6e9c"
  }
  
  if(palName == "Troy"){
    colAlpha <- "#421401" 
    colBeta <- "#8b3a2b" 
    colGamma <- "#c27668" 
    colDelta <- "#7ba0b4" 
    colOmicron <- "#235070"
  }
  
  if(palName == "Hiroshige"){
    colOmicron <- "#ef8a47" 
    colDelta <- "#ffd06f" 
    colAlpha <- "#aadce0" 
    colBeta <- "#72bcd5" 
    colGamma <- "#376795"
  }
  
  list(colAlpha = colAlpha, 
       colBeta = colBeta, 
       colGamma = colGamma, 
       colDelta = colDelta, 
       colOmicron = colOmicron, 
       colOther = colOther, 
       colUnknown = colUnknown)
}

