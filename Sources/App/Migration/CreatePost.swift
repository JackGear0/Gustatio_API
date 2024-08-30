import Fluent

struct CreatePost: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database
            .schema(Post.schema)
            .id()
            .field("text", .string)
            .field("media", .string)
            .field("like_count", .int)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("user_id", .uuid)
            .field("parent_id", .uuid)
            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade, onUpdate: .cascade)
            .foreignKey("parent_id", references: Post.schema, "id", onDelete: .cascade, onUpdate: .cascade)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Post.schema).delete()
    }
    
}

struct AddTags: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database
            .schema(Post.schema)
            .field("tags", .uuid)
            .update()
//        // ler os posts que existem
//        database.query()
//        post.save(on: database)
    }
    
    func revert(on database: Database) async throws {
    }
    
}
//struct AddParentIdFK0: AsyncMigration {
//
//    func prepare(on database: Database) async throws {
//        try await database
//            .schema(Post.schema)
//            .foreignKey("parent_id", references: Post.schema, "id", onDelete: .cascade, onUpdate: .cascade)
//            .update()
////        // ler os posts que existem
////        database.query()
////        post.save(on: database)
//    }
//
//    func revert(on database: Database) async throws {
//    }
//
//}
