import unittest
from request import *

class RequestTest(unittest.TestCase):
    def test_request_from_url(self):
        tests = [
                ['gopher://localhost', Request('localhost', 70, '')],
                ['gopher://localhost/', Request('localhost', 70, '')],
                ['gopher://localhost/1', Request('localhost', 70, '')],
                ['gopher://127.0.0.1/1/test', Request('127.0.0.1', 70, '/test')],
                ['gopher://127.0.0.1:7070/1/test', Request('127.0.0.1', 7070, '/test')],
                ['gopher://example.com/1test/', Request('example.com', 70, 'test/')],
            ]

        for url, expected in tests:
            with self.subTest(url=url):
                actual = request_from_url(url)
                self.assertEqual(actual, expected)
        
if __name__ == '__main__':
    unittest.main()
