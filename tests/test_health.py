import json
import unittest
from urllib.request import urlopen


class HealthCheckTest(unittest.TestCase):
    def test_health_endpoint(self):
        with urlopen("http://127.0.0.1:8080/healthz", timeout=5) as response:
            self.assertEqual(response.status, 200)
            payload = json.load(response)
            self.assertEqual(payload["status"], "ok")
            self.assertEqual(payload["service"], "cloud-ops-demo")


if __name__ == "__main__":
    unittest.main()
