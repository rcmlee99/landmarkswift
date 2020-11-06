//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import Foundation

enum APIError: Error {
  case parsing(description: String)
  case network(description: String)
}
