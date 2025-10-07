from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Dict

from fastapi import FastAPI, HTTPException, Query, Response, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field


@dataclass
class PostRecord:
    id: int
    title: str
    body: str
    author: str


class PostResponse(BaseModel):
    id: int
    title: str
    body: str
    author: str


class PostCreateRequest(BaseModel):
    title: str = Field(..., min_length=1)
    body: str = Field(..., min_length=1)
    author: str = Field(..., min_length=1)


class PostUpdateRequest(BaseModel):
    title: str | None = Field(None, min_length=1)
    body: str | None = Field(None, min_length=1)
    author: str | None = Field(None, min_length=1)


app = FastAPI(
    title="Flutter Template Mock API",
    version="0.1.0",
    description=(
        "FastAPI based mock server used for the Flutter template API demo."
    ),
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def _record_to_response(record: PostRecord) -> PostResponse:
    return PostResponse(**record.__dict__)


def _handle_error_scenario(error_scenario: str | None) -> None:
    """Handle error scenarios based on query parameter."""
    if error_scenario is None:
        return

    if error_scenario == "500":
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error scenario triggered"
        )
    elif error_scenario == "503":
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Service temporarily unavailable"
        )
    elif error_scenario == "404":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Resource not found (forced scenario)"
        )
    elif error_scenario == "validation":
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Validation error scenario triggered"
        )
    elif error_scenario == "timeout":
        import asyncio
        import time
        # Simulate a timeout by sleeping for 30 seconds
        time.sleep(30)


_posts: Dict[int, PostRecord] = {
    1: PostRecord(
        id=1,
        title="Getting started with the mock API",
        body=(
            "This record comes from the in-memory FastAPI server. "
            "You can experiment with GET/POST/PUT/DELETE calls from the Flutter demo."
        ),
        author="Mock Server",
    ),
    2: PostRecord(
        id=2,
        title="Second sample post",
        body="Use PUT to update this entry or DELETE to remove it.",
        author="Mock Server",
    ),
}
_next_post_id = 3


@app.get("/health", tags=["health"])  # pragma: no cover - manual smoke check
async def health_check() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/posts", response_model=list[PostResponse], tags=["posts"])
async def list_posts(
    error_scenario: str | None = Query(None, description="Error scenario: 500, 503, timeout, validation")
) -> list[PostResponse]:
    _handle_error_scenario(error_scenario)
    return [_record_to_response(post) for post in _posts.values()]


@app.get(
    "/posts/{post_id}",
    response_model=PostResponse,
    responses={404: {"description": "Post not found"}},
    tags=["posts"],
)
async def retrieve_post(
    post_id: int,
    error_scenario: str | None = Query(None, description="Error scenario: 500, 503, timeout, validation, 404")
) -> PostResponse:
    _handle_error_scenario(error_scenario)
    try:
        record = _posts[post_id]
    except KeyError as exc:  # pragma: no cover - defensive
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Post {post_id} not found",
        ) from exc
    return _record_to_response(record)


@app.post(
    "/posts",
    response_model=PostResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["posts"],
)
async def create_post(
    payload: PostCreateRequest,
    error_scenario: str | None = Query(None, description="Error scenario: 500, 503, timeout, validation")
) -> PostResponse:
    _handle_error_scenario(error_scenario)
    global _next_post_id

    post_id = _next_post_id
    _next_post_id += 1

    record = PostRecord(
        id=post_id,
        title=payload.title,
        body=payload.body,
        author=payload.author,
    )
    _posts[post_id] = record

    return _record_to_response(record)


@app.put(
    "/posts/{post_id}",
    response_model=PostResponse,
    tags=["posts"],
    responses={404: {"description": "Post not found"}},
)
async def update_post(
    post_id: int,
    payload: PostUpdateRequest,
    error_scenario: str | None = Query(None, description="Error scenario: 500, 503, timeout, validation, 404")
) -> PostResponse:
    _handle_error_scenario(error_scenario)
    try:
        record = _posts[post_id]
    except KeyError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Post {post_id} not found",
        ) from exc

    if payload.title is not None:
        record.title = payload.title
    if payload.body is not None:
        record.body = payload.body
    if payload.author is not None:
        record.author = payload.author

    return _record_to_response(record)


@app.delete(
    "/posts/{post_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={404: {"description": "Post not found"}},
    tags=["posts"],
)
async def delete_post(
    post_id: int,
    error_scenario: str | None = Query(None, description="Error scenario: 500, 503, timeout, validation, 404")
) -> Response:
    _handle_error_scenario(error_scenario)
    try:
        del _posts[post_id]
    except KeyError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Post {post_id} not found",
        ) from exc

    return Response(status_code=status.HTTP_204_NO_CONTENT)


@app.post(
    "/echo",
    tags=["utility"],
    summary="Utility endpoint to echo the payload that was sent",
)
async def echo_payload(body: dict[str, Any]) -> dict[str, Any]:
    """Return whatever JSON payload is sent. Useful for quick checks."""

    return {"echoed": body}
