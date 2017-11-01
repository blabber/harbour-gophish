import unittest
from menu import *

class MenuTest(unittest.TestCase):
    def test_menuitem_from_rawline(self):
        tests = [
                ['0Testitem\t/test\tlocalhost\t70', MenuItem('0', 'Testitem', '/test', 'localhost', '70')],
                ['0Main menu\t\texample.com\t7070', MenuItem('0', 'Main menu', '', 'example.com', '7070')],
                ['1\t\texample.com\t7070', MenuItem('1', '', '', 'example.com', '7070')],
                ['Invalid line', MenuItem('i', 'Invalid line', '', 'fake', '70')],
            ]

        for raw, expected in tests:
            with self.subTest(raw=raw):
                actual = menuitem_from_raw_line(raw)
                self.assertEqual(actual, expected)
        
    def test_menuitem_url(self):
        tests = [
                [MenuItem('1', 'Testitem', '/test', 'localhost', '70'), 'gopher://localhost:70/1/test'],
                [MenuItem(0, 'Main menu', '', 'example.com', '7070'), 'gopher://example.com:7070/0'],
            ]

        for menuitem, expected in tests:
            with self.subTest(menuitem=menuitem):
                actual = menuitem.url()
                self.assertEqual(actual, expected)

if __name__ == '__main__':
    unittest.main()
