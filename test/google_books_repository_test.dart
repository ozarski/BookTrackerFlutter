import 'package:book_tracker/features/search_books/data/data_sources/google_books_api_service.dart';
import 'package:book_tracker/features/search_books/data/models/volume_info.dart';
import 'package:book_tracker/features/search_books/data/repositories/google_books_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'google_books_repository_tests.mocks.dart';

final mockResponse = {
  "items": [
    {
      "volumeInfo": {
        "title": "The Well of Ascension",
        "subtitle": "Book Two of Mistborn",
        "authors": ["Brandon Sanderson"],
        "pageCount": 816,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=Y-41Q9zk32kC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=Y-41Q9zk32kC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "The Well of Ascension",
        "subtitle": "Mistborn Book Two",
        "authors": ["Brandon Sanderson"],
        "pageCount": 874,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=d3ewPoqF04kC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=d3ewPoqF04kC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "Mistborn: The Well of Ascension (Book Two)",
        "authors": ["BookCaps"],
        "pageCount": 43,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=Hz_fyUvafIQC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=Hz_fyUvafIQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "Bohater wieków",
        "authors": ["Brandon Sanderson"],
        "pageCount": 0
      }
    },
    {
      "volumeInfo": {
        "title": "Mistborn Trilogy Boxed Set",
        "subtitle": "The Final Empire, The Well of Ascension, The Hero of Ages",
        "authors": ["Brandon Sanderson"],
        "pageCount": 1008,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=vlc5BAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=vlc5BAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "Mistborn",
        "subtitle": "The Final Empire",
        "authors": ["Brandon Sanderson"],
        "pageCount": 686,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=t_ZYYXZq4RgC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=t_ZYYXZq4RgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "Mistborn: the Well of Ascension (Book Two)",
        "subtitle": "A BookCaps Study Guide",
        "authors": ["BookCaps"],
        "pageCount": 82
      }
    },
    {
      "volumeInfo": {
        "title": "Mistborn",
        "subtitle":
            "The Final Empire - The Well of Ascension - The Hero of Ages",
        "authors": ["Brandon Sanderson"],
        "pageCount": 0,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=UBCYZwEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=UBCYZwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "The Well of Ascension",
        "authors": ["Brandon Sanderson"],
        "pageCount": 592,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=appszQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=appszQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
        }
      }
    },
    {
      "volumeInfo": {
        "title": "Elantris",
        "authors": ["Brandon Sanderson"],
        "pageCount": 682,
        "imageLinks": {
          "smallThumbnail":
              "http://books.google.com/books/content?id=f1pOPwAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
          "thumbnail":
              "http://books.google.com/books/content?id=f1pOPwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
        }
      }
    }
  ]
};

@GenerateMocks([GoogleBooksApiService])
void main() {
  late MockGoogleBooksApiService mockGoogleBooksApiService;
  late GoogleBooksRepository googleBooksRepository;

  setUp(() {
    mockGoogleBooksApiService = MockGoogleBooksApiService();
    googleBooksRepository = GoogleBooksRepository(mockGoogleBooksApiService);
  });

  test('search for book', () async {
    when(mockGoogleBooksApiService.searchBooks(any)).thenAnswer(
      (_) async => Future<Map<String, dynamic>>.value(mockResponse),
    );

    var volumes = await googleBooksRepository.searchBooks('The Well of Ascension');

    expect(volumes, isA<List<VolumeInfo>>());

    expect(volumes.length, 10);

    expect(volumes[0].title, 'The Well of Ascension');
    expect(volumes[0].authors[0], 'Brandon Sanderson');
    expect(volumes[0].pageCount, 816);
    expect(volumes[0].imageLinks!.thumbnail,
        'http://books.google.com/books/content?id=Y-41Q9zk32kC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api');
    
    expect(volumes[2].title, 'Mistborn: The Well of Ascension (Book Two)');
    expect(volumes[2].authors[0], 'BookCaps');
    expect(volumes[2].pageCount, 43);
    expect(volumes[2].imageLinks!.thumbnail,
        'http://books.google.com/books/content?id=Hz_fyUvafIQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api');
  });
}
