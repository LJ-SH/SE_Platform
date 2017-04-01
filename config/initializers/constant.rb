ROLE_DEFINITION = ["admin", "pre_sale", "sales", "post_sale", "inside_sale", "other"]
PRODUCT_CATEGORY = ["CMTS", "AT", "CPE", "WiFi", "Router","Server","Test_Device","IPQAM", "Other"]
COMPANY_STATUS = ["Active", "Inactive", "Pending_decommision", "Other"]

EQUIPMENT_STATUS = ["In_lab","Borrowed","Reserved","Under_repair","Scrapped","Other"]
EQUIPMENT_STATUS_AVAILABLE = EQUIPMENT_STATUS[0]
EQUIPMENT_STATUS_BORROWED = EQUIPMENT_STATUS[1]
EQUIPMENT_STATUS_RESERVED = EQUIPMENT_STATUS[2]
EQUIPMENT_STATUS_CLCT_READY_FOR_RSRV = EQUIPMENT_STATUS.values_at(0)

IOU_STATUS = ["Drafted","Submitted", "Active", "Closed", "Rejected","Other"]
IOU_STATUS_DRAFTED = IOU_STATUS[0]
IOU_STATUS_SUBMITTED = IOU_STATUS[1]
IOU_STATUS_ACTIVE = IOU_STATUS[2]
IOU_STATUS_CLOSED = IOU_STATUS[3]
IOU_STATUS_REJECTED = IOU_STATUS[4]
IOU_STATUS_CLCT_AT_DRAFTED = IOU_STATUS[0..1]
IOU_STATUS_CLCT_AT_SUBMITTED = IOU_STATUS[0..4]
IOU_STATUS_CLCT_AT_ACTIVE = IOU_STATUS[2..3]
IOU_POST_SUBMITTED_STATUS_CLCT = IOU_STATUS[2..5]
IOU_CLOSE_STATUS_CLCT = IOU_STATUS[3..4]

DOC_TYPE = ["RFP", "Training_Material", "Solution_Reference", "Certificate","Corporate_Doc","Industry_Report","Event_Presentation","Sales_Record","Other"]