FROM archlinux:base-devel

ARG repo_name
ENV repo_name=${repo_name}

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm git sudo

RUN useradd --uid 1000 --create-home --shell /bin/bash dockeruser && \
    echo "dockeruser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY ./entrypoint.sh /home/dockeruser/entrypoint.sh
COPY . /home/dockeruser/${repo_name}

USER dockeruser

RUN chmod a+x /home/dockeruser/entrypoint.sh && \
    chown -R dockeruser:dockeruser /home/dockeruser && \
    touch /home/dockeruser/${repo_name}/packages_file.txt && \
    mkdir -p /home/dockeruser/${repo_name}/packages /home/dockeruser/${repo_name}/x86_64 && \
    
WORKDIR /home/dockeruser/${repo_name}

ENTRYPOINT ["/home/dockeruser/entrypoint.sh"]