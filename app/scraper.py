from seleniumwire import webdriver 
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
import time

def capturar_token():
    options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        seleniumwire_options={}, 
        options=options
    )

    print("Abrindo John Deere... Faça o login e aprove no Okta.")
    driver.get("https://jdwarrantysystem.deere.com/")

    token_bearer = None
    
    while not token_bearer:
        for request in driver.requests:
            if 'api/products' in request.url:
                auth = request.headers.get('Authorization')
                if auth and 'Bearer' in auth:
                    token_bearer = auth
                    print("Token Capturado com Sucesso!")
                    break
        time.sleep(2)
    
    driver.quit()
    return token_bearer