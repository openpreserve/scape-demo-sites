#!/usr/bin/python

"""
This is a very simple silenium-driven black-box test, that on a given website
enters something in a form, clicks a button to submit this, waits long enough
to get results back, and checks that there are indeed results.
"""

from sys import exit
import traceback
import unittest

from selenium import webdriver


SITE_URL = "http://localhost:80/flint/index.html"
TEST_FILE = "https://github.com/openplanets/format-corpus/raw/master/govdocs1-error-pdfs/error_set_2/050734.pdf"
TEXT_INPUT_ID = "flintValidateFromUrl"
SUBMIT_BUTTON_ID = "lint-it"
OUTPUT_ELEMENT_ID = "ul.output"


class TestFlint(unittest.TestCase):

    def setUp(self):

        # use the existing headless firefox
        self.driver = webdriver.Firefox()


    def test_flint_is_there(self):
        # navigate to the site of the demonstrator
        self.driver.get(SITE_URL)


        # find the input element where we want to write the filepath to
        input = self.driver.find_element_by_id(TEXT_INPUT_ID)

        # write the path to the test file to the input element
        input.send_keys(TEST_FILE)

        # as this is an asynchronous call we want to give enough time (in seconds) to
        # the background program to rund and to find what's being returned
        self.driver.implicitly_wait(30)

        # click the 'run' button
        self.driver.find_element_by_id(SUBMIT_BUTTON_ID).click()

        # find the ouptut element
        output = self.driver.find_element_by_css_selector(OUTPUT_ELEMENT_ID)

        self.assertTrue('CheckResult' in output.text,
                        msg="Can't find 'CheckResult' in html")
        self.assertTrue('well-formed' in output.text)


if __name__ == '__main__':
    unittest.main()
