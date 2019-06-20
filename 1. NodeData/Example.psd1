@{
	NodeName = "Example"

	LocalConfigurationManager =
	@{

		RefreshFrequencyMins			= "30"
		RefreshMode						= "PUSH"
		ConfigurationMode				= "ApplyAndAutoCorrect"
		RebootNodeIfNeeded				= $False
		AllowModuleOverwrite			= $True
		ConfigurationModeFrequencyMins	= "15"
		MaximumDownloadSizeMB			= "500"
		StatusRetentionTimeInDays		= "10"
	}

	AppliedConfigurations  =
	@{

		PowerSTIG_WindowsServer =
		@{
			OSRole       = "MS"
			OsVersion    = "2012R2"
			StigVersion  = "2.15"
			DomainName   = "USAFRICOM"
			ForestName   = "Mil"
			OrgSettings  = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\Windows-2012R2-MS-2.15.org.xml"
		}

		PowerSTIG_InternetExplorer =
		@{
			StigVersion  	= "1.16"
			BrowserVersion 	= "11"
			OrgSettings  	= "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\InternetExplorer-11-1.16.org.default.xml"
		}

		PowerSTIG_DotNetFrameWork =
		@{
			StigVersion  		= "1.7"
			FrameWorkVersion 	= "4"
			OrgSettings  		= "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\DotNetFramework-4-1.7.org.default.xml"
		}

		PowerSTIG_FireFox =
		@{
			StigVersion  = "4.25"
			InstallDirectory = "C:\Program Files\Mozilla Firefox"
			OrgSettings  = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\FireFox-All-4.25.org.default.xml"
		}

		PowerSTIG_Office_Excel =
		@{
			OfficeApp = "Excel2016"
			StigVersion = "1.2"
			OrgSettings = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\Office-Excel2016-1.2.org.default.xml"
		}

		PowerSTIG_Office_PowerPoint =
		@{
			OfficeApp = "PowerPoint2016"
			StigVersion = "1.1"
			OrgSettings = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\Office-PowerPoint2016-1.1.org.default.xml"
		}

		PowerSTIG_Office_Outlook =
		@{
			OfficeApp = "Outlook2016"
			StigVersion = "1.2"
			OrgSettings = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\Office-Outlook2016-1.2.org.default.xml"
		}

		PowerSTIG_Office_Word =
		@{
			OfficeApp = "Word2016"
			StigVersion = "1.1"
			OrgSettings = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\Office-Word2016-1.1.org.default.xml"
		}

		PowerSTIG_OracleJRE =
		@{
			StigVersion  	= "1.5"
			ConfigPath	 	= "C:\ConfigPath"
			PropertiesPath	= "C:\PropertiesPath"
			OrgSettings  	= "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\OracleJRE-8-1.5.org.default.xml"
		}

		PowerSTIG_SqlServer =
		@{
			StigVersion  	= "1.17"
			SqlVersion		= "2012"
			SqlRole			= "Instance"
			ServerInstance	= "nade05biv02"
			Database		= "Test"
			OrgSettings  	= "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\SqlServer-2012-Database-1.18.org.default.xml"
		}

		PowerSTIG_WebServer =
		@{
			StigVersion  	= "1.7"
			IISVersion 		= "8.5"
			LogPath 		= "C:\LogPath"
			OrgSettings  	= "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\IISServer-8.5-1.7.org.default.xml"
		}

		PowerSTIG_WindowsDefender =
		@{
			StigVersion  = "1.4"
			OrgSettings  = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\WindowsDefender-All-1.4.org.default.xml"
		}

		PowerSTIG_WindowsFireWall =
		@{
			StigVersion  = "1.7"
			OrgSettings  = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\WindowsFirewall-All-1.7.org.default.xml"
		}

		# PowerSTIG_WebSite =
		# @{
		# 	StigVersion  	= "1.7"
		# 	IISVersion 		= "8.5"
		# 	WebSiteName		= "TestSite"
		# 	WebAppPool		= "Test"
		# 	OrgSettings  	= "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\IISSite-8.5-1.7.org.default.xml"
		# }

		# PowerSTIG_WindowsClient =
		# @{
		# 	StigVersion  = "1.16"
		# 	OsVersion    = "10"
		# 	DomainName   = "USAFRICOM"
		# 	ForestName   = "Mil"
		# 	OrgSettings  = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\WindowsClient-10-1.16.org.default.xml"
		# }

		# PowerSTIG_DNSServer =
		# @{
		# 	StigVersion  = "1.11"
		# 	OsVersion    = "2012R2"
		# 	DomainName   = "USAFRICOM"
		# 	ForestName   = "Mil"
		# 	OrgSettings  = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\Organizational Settings\WindowsDnsServer-2012R2-1.11.org.default.xml"
		# }
	}
}
