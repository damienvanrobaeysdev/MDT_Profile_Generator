#========================================================================
#
# Tool Name	: MDT Profile Generator
# Author 	: Damien VAN ROBAEYS
# Date 		: 01/06/2016
# Website	: http://www.systanddeploy.com/
# Twitter	: https://twitter.com/syst_and_deploy
#
#========================================================================

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Data')           				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')        				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('MahApps.Metro.Controls.Dialogs')     | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 	| out-null

Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("Browse_DeploymentShare.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																		 VARIABLES DEFINITION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

$object = New-Object -comObject Shell.Application  

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		BUTTONS AND LABELS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

$Browse_DeploymentShare = $Form.findname("Browse_DeploymentShare")
$DeploymentShare_Textbox = $Form.findname("DeploymentShare_Textbox")
$Run_Tool = $Form.findname("Run_Tool")
$Global:Current_Folder =(get-location).path 
$DeploymentShare_Textbox.IsEnabled = $false

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																						 BUTTONS ACTIONS 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################
	
$Browse_DeploymentShare.Add_Click({	
    $folder = $object.BrowseForFolder(0, $message, 0, 0) 
    If ($folder -ne $null) 
		{ 		
			$global:deploymentshare = $folder.self.Path 
			$DeploymentShare_Textbox.Text =  $deploymentshare		
		}
})

$Run_Tool.Add_Click({	
	If ($DeploymentShare_Textbox -ne $null)
		{
			powershell "$Current_Folder\MDT_Profile_Generator.ps1" -deploymentshare "'$deploymentshare'" 		
		}
	Else
		{
			powershell "$Current_Folder\MDT_Profile_Generator.ps1" 			
		}
})

$Form.ShowDialog() | Out-Null