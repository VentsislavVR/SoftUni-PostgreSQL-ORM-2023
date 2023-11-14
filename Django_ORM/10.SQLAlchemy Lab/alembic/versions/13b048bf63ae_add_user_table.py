"""Add User Table

Revision ID: 13b048bf63ae
Revises: 
Create Date: 2023-11-14 20:38:24.928579

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '13b048bf63ae'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table('users')
    sa.Column('id', sa.Integer(),nullable=False),
    sa.Column('username', sa.String(),nullable=False),
    sa.Column('email', sa.String(),nullable=False),
    sa.PrimaryKeyConstraint('id')


def downgrade() -> None:
    op.drop_table('users')
