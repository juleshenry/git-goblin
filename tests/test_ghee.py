import sys
import os
import json
from unittest import TestCase
from unittest.mock import patch, MagicMock, mock_open

# Add parent directory to sys.path so we can import ghee
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import ghee

class TestOllamaIntegration(TestCase):

    @patch('urllib.request.urlopen')
    def test_get_ollama_model_preferred(self, mock_urlopen):
        # Mock API response with multiple models, including a preferred one
        mock_response = json.dumps({
            "models": [
                {"name": "some-random-model"},
                {"name": "mistral:latest"},
                {"name": "llama3.2:latest"}
            ]
        }).encode('utf-8')
        mock_urlopen.return_value = mock_open(read_data=mock_response).return_value

        model = ghee.get_ollama_model()
        # Should pick the first matched preferred model (llama3.2 over mistral because of order in ghee.py)
        self.assertTrue(model.startswith('llama3.2'))

    @patch('urllib.request.urlopen')
    def test_get_ollama_model_fallback(self, mock_urlopen):
        # Mock API response with no preferred models
        mock_response = json.dumps({
            "models": [
                {"name": "gemma:latest"},
                {"name": "qwen:latest"}
            ]
        }).encode('utf-8')
        mock_urlopen.return_value = mock_open(read_data=mock_response).return_value

        model = ghee.get_ollama_model()
        # Should pick the first available model if no preferred ones
        self.assertEqual(model, 'gemma:latest')

    @patch('urllib.request.urlopen')
    def test_ask_ollama_strips_markdown(self, mock_urlopen):
        # Mock API response returning a markdown code block
        mock_response = json.dumps({
            "response": "```bash\nls -la\n```"
        }).encode('utf-8')
        mock_urlopen.return_value = mock_open(read_data=mock_response).return_value

        command = ghee.ask_ollama("list files", "llama3.2")
        # Should strip the markdown block and language identifier
        self.assertEqual(command, "ls -la")

    @patch('urllib.request.urlopen')
    def test_ask_ollama_raw_string(self, mock_urlopen):
        # Mock API response returning a raw string
        mock_response = json.dumps({
            "response": "ps aux | grep python"
        }).encode('utf-8')
        mock_urlopen.return_value = mock_open(read_data=mock_response).return_value

        command = ghee.ask_ollama("find python processes", "llama3.2")
        self.assertEqual(command, "ps aux | grep python")

    @patch('ghee.get_ollama_model')
    @patch('ghee.ask_ollama')
    @patch('ghee.getch')
    @patch('os.system')
    def test_best_guess_enter_executes_command(self, mock_os_system, mock_getch, mock_ask, mock_get_model):
        mock_get_model.return_value = "llama3.2"
        mock_ask.return_value = "echo 'hello world'"
        # Simulate pressing Enter
        mock_getch.side_effect = ['\r']

        # Provide an empty registry so it guarantees a low score (< 150)
        ghee.run_ollama("some totally random query")

        mock_ask.assert_called_once()
        mock_os_system.assert_called_once_with("echo 'hello world'")

    @patch('ghee.get_ollama_model')
    @patch('ghee.ask_ollama')
    @patch('ghee.getch')
    @patch('os.system')
    def test_best_guess_esc_cancels(self, mock_os_system, mock_getch, mock_ask, mock_get_model):
        mock_get_model.return_value = "llama3.2"
        mock_ask.return_value = "rm -rf /"
        # Simulate pressing Esc (\x1b)
        mock_getch.side_effect = ['\x1b']

        ghee.run_ollama("delete everything")

        mock_ask.assert_called_once()
        # Ensure the dangerous command is NEVER executed
        mock_os_system.assert_not_called()

    @patch('sys.platform', 'darwin')
    @patch('ghee.get_ollama_model')
    @patch('ghee.ask_ollama')
    @patch('ghee.getch')
    @patch('subprocess.run')
    @patch('os.system')
    def test_best_guess_copy_mac(self, mock_os_system, mock_subprocess, mock_getch, mock_ask, mock_get_model):
        mock_get_model.return_value = "llama3.2"
        mock_ask.return_value = "git status"
        # Simulate pressing 'c'
        mock_getch.side_effect = ['c']

        ghee.run_ollama("show git status")

        # Should not execute
        mock_os_system.assert_not_called()
        # Should copy to clipboard
        mock_subprocess.assert_called_once()
        args, kwargs = mock_subprocess.call_args
        self.assertEqual(args[0], ["pbcopy"])
        self.assertEqual(kwargs['input'], b"git status")

if __name__ == '__main__':
    from unittest import main
    main()
