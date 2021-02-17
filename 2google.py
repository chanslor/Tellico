from selenium import webdriver

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--headless")

driver = webdriver.Chrome(options=chrome_options, executable_path="/usr/bin/chromedriver")

driver.get("https://www.tva.com/Environment/Lake-Levels/Valley-Stream-Flows")
print(driver.title)
print(driver.current_url)


# print(driver.page_source)
javaScript = "window.scrollBy(0,1000);"
driver.execute_script(javaScript)

driver.execute_script("return document.readyState")
driver.execute_script("return document.title")
driver.find_element_by_xpath("//button[@name='username']")
#FULL XPATH  /html/body/div[1]/div
#XPATH //*[@id="Contentplaceholder1_T0982884A001_Col00"]

#Javascript path  document.querySelector("#Contentplaceholder1_T0982884A001_Col00")


driver.save_screenshot('TVA.png')


driver.close()
driver.quit()

print("Test Completed")
