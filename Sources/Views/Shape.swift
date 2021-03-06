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

public protocol Shape: View {

    func path(in rect: CGRect) -> CGPath
}

extension Shape {

    public var body: View {
        fatalError()
    }
}

public struct FillShapeView: View {

    public let color: Color
    public let shape: Shape

    @inlinable
    public init(_ color: Color, shape: Shape) {
        self.color = color
        self.shape = shape
    }

    public var body: View {
        fatalError()
    }
}

public struct StrokeShapeView: View {

    public let color: Color
    public let shape: Shape
    public let lineWidth: CGFloat

    @inlinable
    public init(_ color: Color, shape: Shape, lineWidth: CGFloat) {
        self.color = color
        self.shape = shape
        self.lineWidth = lineWidth
    }

    public var body: View {
        fatalError()
    }
}

extension Shape {

    @inlinable
    public func fill(_ color: Color) -> FillShapeView {
        return FillShapeView(color, shape: self)
    }

    @inlinable
    public func stroke(_ color: Color, lineWidth: CGFloat = 1) -> StrokeShapeView {
        return StrokeShapeView(color, shape: self, lineWidth: lineWidth)
    }
}

public struct Circle: Shape, Equatable {

    public init() {
    }

    @inlinable
    public func path(in rect: CGRect) -> CGPath {
        guard !rect.isEmpty else { return CGPath(rect: .zero, transform: nil) }
        var rect = rect
        if rect.width < rect.height {
            rect.origin.y = (rect.height - rect.width) / 2
            rect.size.height = rect.width
        } else if rect.width > rect.height {
            rect.origin.x = (rect.width - rect.height) / 2
            rect.size.width = rect.height
        }
        return CGPath(ellipseIn: rect, transform: nil)
    }
}

public struct Rectangle: Shape, Equatable {

    public init() {
    }

    @inlinable
    public func path(in rect: CGRect) -> CGPath {
        return CGPath(rect: rect, transform: nil)
    }
}

public enum RoundedCornerStyle: Hashable {
    case circular
    case continuous
}

public struct RoundedRectangle: Shape, Equatable {

    public var cornerSize: CGSize
    public var style: RoundedCornerStyle

    @inlinable
    public init(cornerSize: CGSize, style: RoundedCornerStyle = .circular) {
        self.cornerSize = cornerSize
        self.style = style
    }

    @inlinable
    public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular) {
        self.cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        self.style = style
    }

    @inlinable
    public func path(in rect: CGRect) -> CGPath {
        guard rect.width >= cornerSize.width * 2 else { return CGPath(rect: .zero, transform: nil) }
        guard rect.height >= cornerSize.height * 2 else { return CGPath(rect: .zero, transform: nil) }
        return CGPath(roundedRect: rect, cornerWidth: cornerSize.width, cornerHeight: cornerSize.height, transform: nil)
    }
}

public struct Capsule: Shape, Equatable {

    public var style: RoundedCornerStyle

    @inlinable
    public init(style: RoundedCornerStyle = .circular) {
        self.style = style
    }

    @inlinable
    public func path(in rect: CGRect) -> CGPath {
        let radius = min(rect.width, rect.height) / 2
        guard rect.width >= radius * 2 else { return CGPath(rect: .zero, transform: nil) }
        guard rect.height >= radius * 2 else { return CGPath(rect: .zero, transform: nil) }
        return CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
    }
}
