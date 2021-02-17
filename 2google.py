from selenium import webdriver

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--headless")

driver = webdriver.Chrome(options=chrome_options, executable_path="/usr/bin/chromedriver")

driver.get("https://www.tva.com/Environment/Lake-Levels/Valley-Stream-Flows")
print(driver.title)
print(driver.current_url)


driver.close()
driver.quit()

print("Test Completed")
