// MIT License
//
// Copyright (c) 2020 Declarative Hub
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreGraphics

extension Layout {

    public struct ZStack {

        /// Nodes in the stack
        public let nodes: [LayoutNode]

        /// Screen scale
        public let screenScale: CGFloat

        public init(nodes: [LayoutNode], screenScale: CGFloat = 2) {
            self.nodes = nodes
            self.screenScale = screenScale
        }

        /// Calculate the stack geometry fitting `targetSize` and aligned by `alignment`.
        public func contentLayout(fittingSize targetSize: CGSize, alignment: Alignment) -> ContentGeometry {
            var idealSize: CGSize = .zero
            let frames = nodes.map { (node) -> CGRect in
                let size = node.layoutSize(fitting: targetSize)
                var alignedBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                switch alignment.horizontal {
                case .leading:
                    alignedBounds.origin.x = 0
                case .center:
                    alignedBounds.origin.x = (targetSize.width - size.width) / 2
                case .trailing:
                    alignedBounds.origin.x = targetSize.width - size.width
                }
                switch alignment.vertical {
                case .top:
                    alignedBounds.origin.y = 0
                case .center:
                    alignedBounds.origin.y = (targetSize.height - size.height) / 2
                case .bottom:
                    alignedBounds.origin.y = targetSize.height - size.height
                case .firstTextBaseline, .lastTextBaseline:
                    fatalError()
                }
                idealSize = CGSize(width: max(idealSize.width, size.width), height: max(idealSize.height, size.height))
                return alignedBounds
            }
            return ContentGeometry(idealSize: idealSize, frames: frames)
        }
    }
}
