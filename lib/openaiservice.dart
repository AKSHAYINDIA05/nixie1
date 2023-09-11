import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:nixie1/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "system",
                "content": "You are Nixie, a helpful assistant."
              },
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, image, art or anything simliar? $prompt. Simply answer with a yes or no"
              },
            ]
          },
        ),
      );
      log(response.body);
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final response = await dallEAPI(prompt);
            return response;
          default:
            final response = await chatGPTAPI(prompt);
            return response;
        }
      }
    } catch (e) {
      log(
        e.toString(),
      );
    }

    return 'An Internal Error occured';
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({'role': 'user', 'content': prompt});
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode(
          {"model": "gpt-3.5-turbo", "messages": messages},
        ),
      );
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({'role': 'assisstant', 'content': content});
        return content;
      }
    } catch (e) {
      log(
        e.toString(),
      );
    }

    return 'An Internal Error occured';
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({'role': 'user', 'content': prompt});
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode(
          {'prompt': prompt},
        ),
      );
      if (response.statusCode == 200) {
        String imageUrl = jsonDecode(response.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();
        messages.add({'role': 'assisstant', 'content': imageUrl});
        return imageUrl;
      }
    } catch (e) {
      log(
        e.toString(),
      );
    }

    return 'An Internal Error occured';
  }
}
