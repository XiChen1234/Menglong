#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
项目摘要生成器
自动生成项目的目录结构和文件内容摘要
"""

import os
import sys
from pathlib import Path
from typing import List, Tuple


class ProjectSummaryGenerator:
    """项目摘要生成器类"""
    
    def __init__(self, project_root: str = r"c:\Document\Project\menglong\MengLong\test-2",
                 scene_dir: str = "Scene",
                 output_file: str = "project_summary.md"):
        """
        初始化生成器
        
        Args:
            project_root: 项目根目录
            scene_dir: 场景目录名称
            output_file: 输出文件名称
        """
        self.project_root = Path(project_root)
        self.scene_dir = scene_dir
        self.output_file = Path(project_root) / output_file
        self.scene_dir_path = self.project_root / scene_dir
        
        self.total_files = 0
        self.success_files = 0
        self.failed_files = 0
        self.error_log = []
    
    def get_all_files(self, directory_path: Path) -> List[Path]:
        """
        获取目录下所有文件
        
        Args:
            directory_path: 目录路径
            
        Returns:
            文件路径列表
        """
        files = []
        
        try:
            if directory_path.exists():
                files = list(directory_path.rglob("*"))
                files = [f for f in files if f.is_file()]
                print(f"[OK] 找到 {len(files)} 个文件")
            else:
                print(f"[ERROR] 目录不存在: {directory_path}")
                self.error_log.append(f"目录不存在: {directory_path}")
        except Exception as e:
            print(f"[ERROR] 遍历目录失败: {e}")
            self.error_log.append(f"遍历目录失败: {e}")
        
        return files
    
    def generate_directory_tree(self, root_path: Path, base_path: Path) -> List[str]:
        """
        生成目录树结构
        
        Args:
            root_path: 根目录路径
            base_path: 基础目录路径
            
        Returns:
            目录树行列表
        """
        tree_lines = []
        
        def build_tree(path: Path, prefix: str = ""):
            """
            递归构建目录树
            
            Args:
                path: 当前路径
                prefix: 前缀字符串
            """
            try:
                items = sorted(path.iterdir(), key=lambda x: (not x.is_dir(), x.name))
            except Exception:
                return
            
            for i, item in enumerate(items):
                is_last_item = (i == len(items) - 1)
                
                if prefix == "":
                    connector = "+-- "
                    new_prefix = "    " if is_last_item else "|   "
                else:
                    connector = "+-- "
                    new_prefix = f"{prefix}    " if is_last_item else f"{prefix}|   "
                
                tree_lines.append(f"{prefix}{connector}{item.name}")
                
                if item.is_dir():
                    build_tree(item, new_prefix)
        
        build_tree(root_path)
        return tree_lines
    
    def read_file_content(self, file_path: Path) -> str:
        """
        读取文件内容
        
        Args:
            file_path: 文件路径
            
        Returns:
            文件内容，失败返回 None
        """
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print(f"[ERROR] 读取文件失败: {file_path} - {e}")
            self.error_log.append(f"读取文件失败: {file_path} - {e}")
            return None
    
    def generate_summary(self):
        """生成项目摘要"""
        print("")
        print("=" * 40)
        print("  Project Summary Generator")
        print("=" * 40)
        print("")
        
        # 阶段 1: 目录遍历
        print("[Phase 1] 目录遍历")
        all_files = self.get_all_files(self.scene_dir_path)
        self.total_files = len(all_files)
        
        if len(all_files) == 0:
            print("")
            print("[ERROR] 未找到文件，脚本终止")
            return
        
        # 阶段 2: 生成目录结构
        print("")
        print("[Phase 2] 生成目录结构")
        tree_structure = self.generate_directory_tree(self.scene_dir_path, self.scene_dir_path)
        
        # 阶段 3: 构建内容
        print("[Phase 3] 构建内容")
        
        content_lines = []
        content_lines.append("# Project File Summary")
        content_lines.append("")
        content_lines.append("## Directory Structure")
        content_lines.append("")
        content_lines.append("```")
        content_lines.append(f"{self.scene_dir}/")
        
        for line in tree_structure:
            content_lines.append(line)
        
        content_lines.append("```")
        content_lines.append("")
        content_lines.append("## File Contents")
        content_lines.append("")
        
        # 阶段 4: 处理文件
        print("[Phase 4] 处理文件")
        print("处理文件中...")
        print("")
        
        sorted_files = sorted(all_files, key=lambda f: str(f.relative_to(self.scene_dir_path)))
        
        for file_path in sorted_files:
            relative_path = file_path.relative_to(self.scene_dir_path)
            relative_path_str = str(relative_path).replace('\\', '/')
            
            file_content = self.read_file_content(file_path)
            
            if file_content is not None:
                content_lines.append(f"============{relative_path_str}============")
                content_lines.append(file_content)
                
                self.success_files += 1
                print(f"  [OK] {relative_path_str}")
            else:
                self.failed_files += 1
        
        # 阶段 5: 写入输出文件
        print("")
        print("[Phase 5] 写入输出文件")
        
        try:
            with open(self.output_file, 'w', encoding='utf-8') as f:
                f.write('\n'.join(content_lines))
            print(f"[OK] 输出文件已写入: {self.output_file}")
        except Exception as e:
            print(f"[ERROR] 写入输出文件失败: {e}")
            self.error_log.append(f"写入输出文件失败: {e}")
        
        # 执行摘要
        print("")
        print("=" * 40)
        print("  Execution Summary")
        print("=" * 40)
        print(f"Total files: {self.total_files}")
        print(f"Successful: {self.success_files}")
        print(f"Failed: {self.failed_files}")
        
        if len(self.error_log) > 0:
            print("")
            print("Error Log:")
            for error in self.error_log:
                print(f"  - {error}")
        
        print("")
        print("[OK] 脚本执行完成!")
        print(f"Output file: {self.output_file}")
        print("")


def main():
    """主函数"""
    generator = ProjectSummaryGenerator()
    generator.generate_summary()


if __name__ == "__main__":
    main()
