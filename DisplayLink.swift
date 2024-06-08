
import Combine

public protocol DisplayLinkProtocol: AnyObject {
    var frameSubject: PassthroughSubject<CFTimeInterval, Never> { get }
    func activate()
    var timestamp: CFTimeInterval { get }
}

#if os(macOS)
import CoreVideo

public final class DisplayLink: DisplayLinkProtocol {
    public var frameSubject = PassthroughSubject<CFTimeInterval, Never>()
    public private(set) var timestamp: CFTimeInterval = CFAbsoluteTimeGetCurrent()
    private var link: CVDisplayLink?
    public init() {}
    deinit {
        guard let link = link else { return }
        CVDisplayLinkStop(link)
    }
    private var opaquePointerToSelf: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(
            Unmanaged
                .passUnretained(self)
                .toOpaque()
        )
    }
    public func activate() {
        CVDisplayLinkCreateWithActiveCGDisplays(&link)
        guard let link = link else { return }
        CVDisplayLinkSetOutputHandler(link) { [unowned self] link, now, outputTime, flagsIn, flagsOut in
            consume(now)
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(link)
    }
    private func screenDidRender() {
        let timestamp = timestamp
        frameSubject.send(timestamp)
    }
    private func consume(_ now: UnsafePointer<CVTimeStamp>) {
        timestamp = Double(now.pointee.hostTime) / Double(now.pointee.videoTimeScale)
        screenDidRender()
    }
}
#elseif os(iOS)
import QuartzCore

public final class DisplayLink: DisplayLinkProtocol {
    public var frameSubject = PassthroughSubject<CFTimeInterval, Never>()
    public var timestamp: CFTimeInterval {  link.timestamp }
    private lazy var link = makeLink()
    public init() {}
    deinit {
        link.remove(from: .main, forMode: .common)
    }
    public func activate() {
        link.add(to: .main, forMode: .common)
    }
    private func makeLink() -> CADisplayLink {
        CADisplayLink(target: self, selector: #selector(screenDidRender))
    }
    @objc private func screenDidRender() {
        let timestamp = timestamp
        frameSubject.send(timestamp)
    }
}
#endif
