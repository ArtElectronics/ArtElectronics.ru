-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: art_electronics_ru_dev
-- ------------------------------------------------------
-- Server version	5.5.35-0ubuntu0.12.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attached_files`
--

DROP TABLE IF EXISTS `attached_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attached_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `storage_id` int(11) DEFAULT NULL,
  `storage_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment_file_size` int(11) DEFAULT '0',
  `attachment_updated_at` datetime DEFAULT NULL,
  `processing` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'none',
  `watermark` tinyint(1) DEFAULT '0',
  `watermark_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `audits`
--

DROP TABLE IF EXISTS `audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `obj_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `obj_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `controller_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fullpath` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `referer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_addr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `short_description` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_authors_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authorships`
--

DROP TABLE IF EXISTS `authorships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authorships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_authorships_on_post_id` (`post_id`),
  KEY `index_authorships_on_author_id` (`author_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `holder_id` int(11) DEFAULT NULL,
  `commentable_id` int(11) DEFAULT NULL,
  `commentable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `commentable_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `commentable_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `commentable_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `anchor` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contacts` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_content` text COLLATE utf8_unicode_ci,
  `content` text COLLATE utf8_unicode_ci,
  `view_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'undefined',
  `referer` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'undefined',
  `user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'undefined',
  `tolerance_time` int(11) DEFAULT NULL,
  `spam` tinyint(1) DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=690 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delayed_jobs`
--

DROP TABLE IF EXISTS `delayed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) NOT NULL DEFAULT '0',
  `attempts` int(11) NOT NULL DEFAULT '0',
  `handler` text COLLATE utf8_unicode_ci NOT NULL,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hubs`
--

DROP TABLE IF EXISTS `hubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hubs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `hub_id` int(11) DEFAULT NULL,
  `author` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `copyright` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_intro` text COLLATE utf8_unicode_ci,
  `intro` text COLLATE utf8_unicode_ci,
  `raw_content` text COLLATE utf8_unicode_ci,
  `content` text COLLATE utf8_unicode_ci,
  `hub_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `inline_tags` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `legacy_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `pubs_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'posts',
  `optgroup` tinyint(1) DEFAULT '0',
  `pubs_draft_count` int(11) DEFAULT '0',
  `pubs_published_count` int(11) DEFAULT '0',
  `pubs_deleted_count` int(11) DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT '0',
  `main_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_image_file_size` int(11) DEFAULT '0',
  `main_image_updated_at` datetime DEFAULT NULL,
  `show_count` int(11) DEFAULT '0',
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `moderation_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'raw',
  `moderator_note` text COLLATE utf8_unicode_ci,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `friendly_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storage_files_count` int(11) DEFAULT '0',
  `storage_files_size` int(11) DEFAULT '0',
  `draft_comments_count` int(11) DEFAULT '0',
  `published_comments_count` int(11) DEFAULT '0',
  `deleted_comments_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `hub_id` int(11) DEFAULT NULL,
  `author` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `copyright` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_intro` text COLLATE utf8_unicode_ci,
  `intro` text COLLATE utf8_unicode_ci,
  `raw_content` text COLLATE utf8_unicode_ci,
  `content` text COLLATE utf8_unicode_ci,
  `hub_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `inline_tags` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `legacy_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT '0',
  `main_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_image_file_size` int(11) DEFAULT '0',
  `main_image_updated_at` datetime DEFAULT NULL,
  `show_count` int(11) DEFAULT '0',
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `moderation_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'raw',
  `moderator_note` text COLLATE utf8_unicode_ci,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `friendly_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storage_files_count` int(11) DEFAULT '0',
  `storage_files_size` int(11) DEFAULT '0',
  `draft_comments_count` int(11) DEFAULT '0',
  `published_comments_count` int(11) DEFAULT '0',
  `deleted_comments_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `hub_id` int(11) DEFAULT NULL,
  `author` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `copyright` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_intro` text COLLATE utf8_unicode_ci,
  `intro` text COLLATE utf8_unicode_ci,
  `raw_content` mediumtext COLLATE utf8_unicode_ci,
  `content` mediumtext COLLATE utf8_unicode_ci,
  `hub_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `inline_tags` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `legacy_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT '0',
  `main_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_image_file_size` int(11) DEFAULT '0',
  `main_image_updated_at` datetime DEFAULT NULL,
  `show_count` int(11) DEFAULT '0',
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `moderation_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'raw',
  `moderator_note` text COLLATE utf8_unicode_ci,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `friendly_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storage_files_count` int(11) DEFAULT '0',
  `storage_files_size` int(11) DEFAULT '0',
  `draft_comments_count` int(11) DEFAULT '0',
  `published_comments_count` int(11) DEFAULT '0',
  `deleted_comments_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=737 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `the_role` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggings_idx` (`tag_id`,`taggable_id`,`taggable_type`,`context`,`tagger_id`,`tagger_type`)
) ENGINE=InnoDB AUTO_INCREMENT=27119 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9717 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `open_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crypted_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `show_count` int(11) DEFAULT '0',
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'active',
  `hubs_count` int(11) DEFAULT '0',
  `posts_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_me_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_me_token_expires_at` datetime DEFAULT NULL,
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_token_expires_at` datetime DEFAULT NULL,
  `reset_password_email_sent_at` datetime DEFAULT NULL,
  `all_attached_files_count` int(11) DEFAULT '0',
  `all_attached_files_size` int(11) DEFAULT '0',
  `storage_files_count` int(11) DEFAULT '0',
  `storage_files_size` int(11) DEFAULT '0',
  `my_draft_comments_count` int(11) DEFAULT '0',
  `my_published_comments_count` int(11) DEFAULT '0',
  `my_comments_count` int(11) DEFAULT '0',
  `draft_comcoms_count` int(11) DEFAULT '0',
  `published_comcoms_count` int(11) DEFAULT '0',
  `deleted_comcoms_count` int(11) DEFAULT '0',
  `spam_comcoms_count` int(11) DEFAULT '0',
  `draft_comments_count` int(11) DEFAULT '0',
  `published_comments_count` int(11) DEFAULT '0',
  `deleted_comments_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_users_on_remember_me_token` (`remember_me_token`),
  KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-30 12:09:30
INSERT INTO schema_migrations (version) VALUES ('20130111174314');

INSERT INTO schema_migrations (version) VALUES ('20130111174315');

INSERT INTO schema_migrations (version) VALUES ('20130111174316');

INSERT INTO schema_migrations (version) VALUES ('20130111174400');

INSERT INTO schema_migrations (version) VALUES ('20130111200446');

INSERT INTO schema_migrations (version) VALUES ('20130111211245');

INSERT INTO schema_migrations (version) VALUES ('20130112071346');

INSERT INTO schema_migrations (version) VALUES ('20130112071350');

INSERT INTO schema_migrations (version) VALUES ('20130112071835');

INSERT INTO schema_migrations (version) VALUES ('20130130171802');

INSERT INTO schema_migrations (version) VALUES ('20130501154455');

INSERT INTO schema_migrations (version) VALUES ('20130501154456');

INSERT INTO schema_migrations (version) VALUES ('20130510182558');

INSERT INTO schema_migrations (version) VALUES ('20130907115151');

INSERT INTO schema_migrations (version) VALUES ('20131105080444');

INSERT INTO schema_migrations (version) VALUES ('20131105080445');

INSERT INTO schema_migrations (version) VALUES ('20131105080446');

INSERT INTO schema_migrations (version) VALUES ('20131119095510');

INSERT INTO schema_migrations (version) VALUES ('20140127075019');

INSERT INTO schema_migrations (version) VALUES ('20140130042114');

INSERT INTO schema_migrations (version) VALUES ('20140130042128');

