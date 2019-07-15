@echo.
@ipconfig/all | find " Description"
@ipconfig/all | find "IPv4 Address"
@ipconfig/all | find "Subnet Mask"
@ipconfig/all | find " Physical Address"
echo.
@pause