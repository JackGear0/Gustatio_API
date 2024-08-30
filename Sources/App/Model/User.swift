import Vapor
import Fluent

final class User: Model {
    
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "avatar")
    var avatar: String?
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user)
    var posts: [Post]
    
    @Field(key: "following")
    var following: [UUID]
    
    @Field(key: "followers")
    var followers: [UUID]
    
    init() { }
    
    init(username: String, name: String, avatar: String?, password: String, following: [UUID], followers: [UUID]) {
        self.username = username
        self.name = name
        self.avatar = avatar
        self.password = password
        self.following = following
        self.followers = followers
    }
    
}

extension User: Content { }

extension User {
    
    struct Input: Content {
        var username: String
        var name: String
        var password: String
    }
    
    struct Public: Content {
        var id: UUID?
        var username: String
        var name: String
        var avatar: String?
        var following: [UUID]
        var followers: [UUID]
    }
    
    convenience init(_ input: Input) throws {
        self.init(username: input.username, name: input.name, avatar: nil, password: try Bcrypt.hash(input.password), following: [], followers: [])
    }
    
    var `public`: Public {
        Public(id: self.id, username: self.username, name: self.name, avatar: self.avatar, following: self.following, followers: self.followers)
    }
    
}

extension User {
    
    func token(source: SessionSource) throws -> Token {
        let token = [UInt8].random(count: 16).base64
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate = calendar.date(byAdding: .hour, value: 8, to: Date())
        return try Token(userId: requireID(), token: token, source: source, expiresAt: expiryDate)
    }
    
}

extension User: ModelAuthenticatable {
    
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
}
