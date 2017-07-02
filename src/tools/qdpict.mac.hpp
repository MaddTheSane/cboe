//
//  qdpict.mac.hpp
//  BoE
//
//  Created by C.W. Betts on 7/2/17.
//
//

#ifndef qdpict_mac_h
#define qdpict_mac_h

#include <SFML/Graphics/Image.hpp>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

extern bool tryLoadPictFromResourceFile(fs::path& gpath, sf::Image& graphics_store);

#endif /* qdpict_mac_h */
