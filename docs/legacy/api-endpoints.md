# Legacy API Endpoints

All endpoints extracted from `Legacy/DiasUI/src/app/pages/services/gen/*.ts`.
Grouped by service/domain. Base URL prefix is `BaseAPIService.WebApiUrl` unless noted.

> **New DiasUI prefix**: All `WebApiUrl` endpoints become `/api/legacy/API/Api/...`

---

## AccountInternalService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/AccountInternal/GetAllUsers` |
| GET | `/Api/AccountInternal/GetAllRoles` |
| GET | `/Api/AccountInternal/SearchLocationRoles/{filter}` |
| POST | `/Api/AccountInternal/GetAllFilterDTO` |

## AccountService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/Account/GetAllApplicationGroups` |
| GET | `/Api/Account/GetApplicationGroup/{id}` |
| POST | `/Api/Account/SaveApplicationGroup` |
| DELETE | `/Api/Account/DeleteApplicationGroup/{id}` |
| GET | `/Api/Account/GetApplicationUserGroups/{userId}` |
| POST | `/Api/Account/SaveApplicationUserGroups` |

## ActivityService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Activity/GetAll` |
| GET | `/Api/Activity/GetByID/{id}` |
| POST | `/Api/Activity/Save` |
| DELETE | `/Api/Activity/Delete/{id}` |

## AdminTextService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/AdminText/GetAll` |
| GET | `/Api/AdminText/GetByID/{id}` |
| POST | `/Api/AdminText/Save` |
| DELETE | `/Api/AdminText/Delete/{id}` |

## AssignObjectService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/AssignObject/GetAll` |
| GET | `/Api/AssignObject/GetByID/{id}` |
| POST | `/Api/AssignObject/Save` |

## BillingService
> Uses `ConfigModel.BillingServiceUrl` — proxied server-side by BFF

| Method | Endpoint |
|--------|----------|
| GET | `billingtypes` |
| POST | `orders/create` |
| GET | `orders/{id}` |
| GET | `businesscentral/token` |

## CertificateService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Certificate/GetAll` |
| GET | `/Api/Certificate/GetByID/{id}` |
| POST | `/Api/Certificate/Save` |
| GET | `/Api/Certificate/GetArchive` |

## ChoseBillingTypesService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/ChosenBillingTypes/GetAll` |
| POST | `/Api/ChosenBillingTypes/Save` |

## ContactPersonService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/ContactPerson/GetAll` |
| GET | `/Api/ContactPerson/GetByID/{id}` |
| POST | `/Api/ContactPerson/Save` |
| DELETE | `/Api/ContactPerson/Delete/{id}` |

## CourseCatalogService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/CourseCatalog/GetAll` |
| GET | `/Api/CourseCatalog/GetByID/{id}` |
| POST | `/Api/CourseCatalog/Save` |

## CourseCategoryService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/CourseCategory/GetAll` |
| GET | `/Api/CourseCategory/GetAllCategories` |
| POST | `/Api/CourseCategory/Save` |
| POST | `/Api/CourseCategory/Delete` |

## CourseService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Course/GetAll` |
| GET | `/Api/Course/GetByID/{id}` |
| POST | `/Api/Course/Save` |
| DELETE | `/Api/Course/Delete/{id}` |
| GET | `/Api/Course/GetCourseInfo/{id}` |
| POST | `/Api/Course/SaveCourseInfo` |
| POST | `/Api/Course/GetAllCourseInfo` |

## CprService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/CPR/GetByID/{cpr}` |

## CustomerService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Customer/GetAll` |
| GET | `/Api/Customer/GetByID/{id}` |
| POST | `/Api/Customer/Save` |
| DELETE | `/Api/Customer/Delete/{id}` |
| GET | `/Api/Customer/GetSalesRequests` |
| POST | `/Api/Customer/UpdateSalesPerson` |

## CustomerInterestService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/CustomerInterest/GetAll` |
| GET | `/Api/CustomerInterest/GetByID/{id}` |
| POST | `/Api/CustomerInterest/Save` |
| DELETE | `/Api/CustomerInterest/Delete/{id}` |
| POST | `/Api/CustomerInterest/Sync` |

## CVRService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/CVR/GetByID/{cvr}` |

## DataCorrectionService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/DataCorrection/CorrectData` |

## DomainTMKKursistTypeService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/DomainTMKKursistType/GetAll` |
| POST | `/Api/DomainTMKKursistType/Save` |

## DomainVaerdierService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/DomainVaerdier/GetAll` |
| POST | `/Api/DomainVaerdier/Save` |

## DWHService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/DWH/GetAll` |
| POST | `/Api/DWH/Report` |
| GET | `/Api/DWH/GetReported` |

## HoldAflysningsAarsagService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/HoldAflysningsAarsag/GetAll` |
| GET | `/Api/HoldAflysningsAarsag/GetByID/{id}` |
| POST | `/Api/HoldAflysningsAarsag/Save` |
| DELETE | `/Api/HoldAflysningsAarsag/Delete/{id}` |

## HoldSprogService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/HoldSprog/GetAll` |
| POST | `/Api/HoldSprog/Save` |

## InsuranceService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Insurance/GetAll` |
| GET | `/Api/Insurance/GetByID/{id}` |
| POST | `/Api/Insurance/Save` |
| DELETE | `/Api/Insurance/Delete/{id}` |

## JobService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Job/GetAll` |
| GET | `/Api/Job/GetByID/{id}` |

## KeyTemplateService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/KeyTemplate/GetAll` |
| GET | `/Api/KeyTemplate/GetByID/{id}` |
| POST | `/Api/KeyTemplate/Save` |
| DELETE | `/Api/KeyTemplate/Delete/{id}` |

## KeyWordService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/KeyWord/GetAll` |
| GET | `/Api/KeyWord/GetByID/{id}` |
| POST | `/Api/KeyWord/Save` |

## LocationService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Location/GetAllFilterDTO` |
| GET | `/Api/Location/GetAll` |
| GET | `/Api/Location/GetByID/{id}` |
| POST | `/Api/Location/Save` |
| DELETE | `/api/Location/{id}` |
| POST | `/Api/Location/LocationExist` |
| GET | `/Api/Location/GetLocationRoles/{id}` |
| POST | `/Api/Location/SaveLocationRoles/{id}` |
| GET | `/Api/Location/GetLocationsForSchool/{schoolcode}` |
| GET | `/Api/Location/getCateringLocations` |
| GET | `/Api/Location/GetEnabledFinanceLocations` |

## NoteStatusService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/NoteStatus/GetAll` |
| GET | `/Api/NoteStatus/GetByID/{id}` |
| POST | `/Api/NoteStatus/Save` |

## ObjectTypesService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/ObjectTypes/GetAll` |

## OmraadeService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/Omraade/GetSelectableAreasForLocation` |
| POST | `/Api/Omraade/GetAll` |
| GET | `/Api/Omraade/GetByID/{id}` |
| POST | `/Api/Omraade/Save` |
| DELETE | `/Api/Omraade/Delete/{id}` |

## PackagesService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Packages/GetAll` |
| GET | `/Api/Packages/GetByID/{id}` |
| POST | `/Api/Packages/Save` |
| DELETE | `/Api/Packages/Delete/{id}` |
| GET | `/Api/Packages/GetPackageCourses/{id}` |
| POST | `/Api/Packages/SavePackageCourses` |

## PriceService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Price/GetAll` |
| GET | `/Api/Price/GetByID/{id}` |
| POST | `/Api/Price/Save` |
| DELETE | `/Api/Price/Delete/{id}` |
| POST | `/Api/Price/GetAllFees` |
| GET | `/Api/Price/GetFeeByID/{id}` |
| POST | `/Api/Price/SaveFee` |
| DELETE | `/Api/Price/DeleteFee/{id}` |
| GET | `/Api/Price/GetPriceGroups` |

## ProtocolService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Protocol/GetAll` |
| GET | `/Api/Protocol/GetByID/{id}` |
| POST | `/Api/Protocol/Save` |
| POST | `/Api/Protocol/GetProtocolDays` |
| POST | `/Api/Protocol/SaveProtocolDays` |

## RegionService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Region/GetByRoadAndZipCode` |

## ReportService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Report/MissingHours` |
| POST | `/Api/Report/ActivityPeriod` |
| POST | `/Api/Report/MissingDocuments` |
| POST | `/Api/Report/CampaignContact` |

## RepportToUVMService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/ReportToUVM/GetAll` |
| POST | `/Api/ReportToUVM/Report` |
| POST | `/Api/ReportToUVM/Resend` |

## RoleService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Role/GetAll` |
| GET | `/Api/Role/GetByID/{id}` |
| POST | `/Api/Role/Save` |
| DELETE | `/Api/Role/Delete/{id}` |

## SchoolService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/school/GetAllSchools` |
| GET | `/Api/school/GetSchoolByScoolCode/{id}` |
| POST | `/Api/school/Save` |
| GET | `/Api/school/GetAll` |
| GET | `/Api/school/GetEfteruddannelse/{schoolcode}` |
| POST | `/Api/school/SaveEfteruddannelse` |
| GET | `/Api/school/GetSchoolSettings/{schoolcode}` |
| POST | `/Api/school/SaveSchoolSettings` |

## SchoolAmuService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/SchoolAmu/GetAll` |
| GET | `/Api/SchoolAmu/GetByID/{id}` |
| POST | `/Api/SchoolAmu/Save` |
| DELETE | `/Api/SchoolAmu/Delete/{id}` |

## SearchService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/Search/SearchInvoice/{term}` |
| POST | `/Api/Search/SearchInvoiceFilterDTO` |

## SessionService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Session/GetAll` |
| GET | `/Api/Session/GetByID/{id}` |
| POST | `/Api/Session/Save` |
| DELETE | `/Api/Session/Delete/{id}` |
| GET | `/Api/Session/GetSessionDates/{id}` |
| POST | `/Api/Session/SaveSessionDates` |
| POST | `/Api/Session/CopySession` |
| GET | `/Api/Session/GetSessionSignups/{id}` |
| POST | `/Api/Session/ChangeSessionCourse` |

## SignupService
> Some endpoints use `DiasServicesApiUrl` (Gateway)

| Method | Endpoint | Base |
|--------|----------|------|
| POST | `/Api/Signup/GetAll` | WebApiUrl |
| GET | `/Api/Signup/GetByID/{id}` | WebApiUrl |
| POST | `/Api/Signup/Save` | WebApiUrl |
| DELETE | `/Api/Signup/Delete/{id}` | WebApiUrl |
| POST | `/Api/Signup/Cancel` | WebApiUrl |
| POST | `Signup/Ordersignup` | DiasServicesApiUrl |
| GET | `Signup/{schoolcode}` | DiasServicesApiUrl |

## StatusTypeService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/StatusType/GetAll` |
| GET | `/Api/StatusType/GetByID/{id}` |
| POST | `/Api/StatusType/Save` |
| DELETE | `/Api/StatusType/Delete/{id}` |

## StudentService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Student/GetAll` |
| GET | `/Api/Student/GetStudentById/{id}` |
| POST | `/Api/Student/POST` |
| POST | `/Api/Student/UpdateStudent` |
| POST | `/Api/Student/UpdateStudents` |
| DELETE | `/api/Student/{id}` |
| POST | `/Api/Student/GetAllStudentTypes` |
| POST | `/Api/Student/SaveStudentType` |
| POST | `/Api/Student/StudentTypeExists` |
| POST | `/Api/Student/UnsetCustomer` |
| POST | `/Api/Student/GetAllRequisitionTypes` |
| POST | `/Api/Student/SaveRequisitionType` |

## StudentAssignedService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/StudentAssigned/GetAll` |
| POST | `/Api/StudentAssigned/Save` |

## SystemAssignObjectService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/SystemAssignObject/GetAll` |
| GET | `/Api/SystemAssignObject/Get/{id}` |
| POST | `/Api/SystemAssignObject/Save` |
| POST | `/Api/SystemAssignObject/SaveList/{assigntotypeid}/{objectid}/{typeid}` |
| DELETE | `/Api/SystemAssignObject/Delete/{id}` |
| GET | `/Api/SystemAssignObject/GetAssignObjectFromAssignTO/{assigntypeid}/{assigntoobjectid}/{assigntotypeid}` |

## TemplateService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/Template/GetAllF` |
| GET | `/Api/Template/GetAll` |
| GET | `/Api/Template/GetByID/{id}` |
| POST | `/Api/Template/Save` |
| POST | `/api/Template` |
| PUT | `/api/Template/{id}` |
| GET | `/Api/Template/Delete` |
| POST | `/Api/Template/Print` |
| POST | `/Api/Template/Printeboks` |
| POST | `/Api/Template/PrintOffer` |
| POST | `/Api/Template/SendOffer` |
| POST | `/Api/Template/SmsEmail` |
| POST | `/Api/Template/GetOffterDTOInfo` |

## TestCourseService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/TestCourse/GetTests` |

## TMKService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/TMK/GetAll` |

## UdmeldingsInformationService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/UdmeldingsInformation/GetAll` |
| GET | `/Api/UdmeldingsInformation/CheckAndCreateUmoData` |

## UMOLogService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/UMOLOG/GetAllCourse` |
| POST | `/Api/UMOLOG/GetAllCRFLINE` |
| POST | `/Api/UMOLOG/GetAllDomain` |
| POST | `/Api/UMOLOG/GetAllPrice` |
| POST | `/Api/UMOLOG/GetAllSchoolApprovals` |
| POST | `/Api/UMOLOG/GETALLTMK` |
| GET | `/Api/UMOLOG/GETCourseByID/{id}` |
| GET | `/Api/UMOLOG/GETCRFByID/{id}` |
| GET | `/Api/UMOLOG/GETDomainByID/{id}` |
| GET | `/Api/UMOLOG/GETPriceByID/{id}` |
| GET | `/Api/UMOLOG/GETSchoolByID/{id}` |
| GET | `/Api/UMOLOG/GETTMKByID/{id}` |

## UtilsService
| Method | Endpoint |
|--------|----------|
| GET | `/Api/Utils/GetAllTypeOfCategories` |
| GET | `/Api/Utils/GetCategoryName/{id}` |
| GET | `/Api/Utils/ChangeQSetting/{id}` |
| GET | `/Api/Utils/RandomizeStudent/{id}` |
| GET | `/Api/Utils/searchTypeOfCategories/{term}/{pageSize}/{pageIndex}` |

## VoksenUddannelseService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/VoksenUddannelse/VoksenUddannelseSynkronisering` |
| GET | `/Api/VoksenUddannelse/SletHoldHosVoksenUddannelse/{holdID}` |

## WebsiteCategoriesService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/WebsiteCategories/GetAll` |
| GET | `/Api/WebsiteCategories/GetAllWebsiteCategories` |
| POST | `/Api/WebsiteCategories/Save` |
| DELETE | `/Api/WebsiteCategories/Delete` |

## WebSiteSignupService
| Method | Endpoint |
|--------|----------|
| POST | `/Api/WebsiteSignup/GetAll` |
| GET | `/Api/WebsiteSignup/GetByID/{id}` |
| POST | `/Api/WebsiteSignup/Save` |
